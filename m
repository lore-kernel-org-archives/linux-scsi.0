From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: write cache and read ahead
Date: Sun, 21 Aug 2005 19:56:50 -0400
Message-ID: <430914C2.8030301@pobox.com>
References: <43085209.50405@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:33256 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751192AbVHUX5C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Aug 2005 19:57:02 -0400
In-Reply-To: <43085209.50405@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>

Douglas Gilbert wrote:
> The attachment is for discussion. It adds MODE SELECT
> support to libata allowing the write(back) cache and
> read ahead to be manipulated by users [i.e. the WCE and
> DRA **  bits in the SCSI Caching mode page].

In general I approve of this concept.  I've wanted libata to do MODE 
SELECT for a while, but have been too slack to worry about it myself.


> The patch is against lk 2.6.13-rc6 and includes the
> SSU patch (but not the TUR patch).
> 
> It highlights several issues with libata:
>    - may need hook so SCSI command specific logic can be
>      executed _after_ a ATA command has completed successfully

You should just be able to do this via ata_queued_cmd completion 
callback.  See Tejun Heo's "mod15write quirk fix" patch for an example.


>    - one SCSI command can map to two or more
>      ATA commands (e.g. a MODE SELECT caching
>      page that changes the state of both WCE and DRA)
>      I cannot see a graceful way to do this with libata.

ditto above comment


>    - patch generalizes error processing but probably
>      not enough

what, ata_scsi_invalid_field() and ata_scsi_set_sense() use?  Those look 
like a good start to me.


>    - may need lighter weight version of
>      ata_dev_identify() when the "dev->id" array needs
>      to be resync-ed (e.g. as required by the ATA information
>      VPD page in sat-r05)

well no implementation will be completely "light"...  ideally each time 
you attempt to change the configuration, you should IDENTIFY DEVICE 
again to make sure that you achieved the desired effect.  We should do 
this after SET FEATURES - XFER MODE in fact, but don't ATM.


> ChangeLog:
>    - add MODE SELECT (6 and 10) handling; active for
>      WCE and DRA in Caching mode page
>    - add block descriptor to MODE SENSE command
>    - make various changes to sync with sat-r05 (as
>      noted in source)
>    - answer some "FIXME" questions in code and flag
>      points for extra work
> Not to be applied to mainline kernel yet.

As bits become ready for mainline, please submit them as separate 
patches.  For example, you could separate out simple stuff like 
ata_scsi_set_sense() use, and go ahead and get that into the kernel.


> @@ -579,6 +631,10 @@
>  	}
>  
>  	if (scsicmd[0] == READ_6 || scsicmd[0] == WRITE_6) {
> +		/*
> +		 * FIXME: for READ_6 and WRITE_6 (only)
> +		 * transfer_len==0 -> 256 blocks !!
> +		 */
>  		qc->nsect = tf->nsect = scsicmd[4];
>  		tf->lbal = scsicmd[3];
>  		tf->lbam = scsicmd[2];

Good catch.  Interested in submitting a fix for this sooner rather than 
later?


> @@ -994,6 +1078,13 @@
>  	*ptr_io = ptr;
>  }
>  
> +static const u8 def_caching_mpage[] = {
> +		0x8,				/* page code */
> +		0x12,				/* page length */
> +		0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	/* 10 zeroes */
> +		0, 0, 0, 0, 0, 0, 0, 0		/* 8 zeroes */
> +	};
> +
>  /**
>   *	ata_msense_caching - Simulate MODE SENSE caching info page
>   *	@id: device IDENTIFY data
> @@ -1011,13 +1102,9 @@
>  static unsigned int ata_msense_caching(u16 *id, u8 **ptr_io,
>  				       const u8 *last)
>  {
> -	u8 page[] = {
> -		0x8,				/* page code */
> -		0x12,				/* page length */
> -		0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	/* 10 zeroes */
> -		0, 0, 0, 0, 0, 0, 0, 0		/* 8 zeroes */
> -	};
> +	u8 page[0x12 + 2];
>  
> +	memcpy(page, def_caching_mpage, sizeof(page));
>  	if (ata_id_wcache_enabled(id))
>  		page[2] |= (1 << 2);	/* write cache enable */
>  	if (!ata_id_rahead_enabled(id))

Don't define the size of automatic variable 'page' with numeric 
constants.  That sort of method is very error-prone.


> @@ -1093,28 +1182,52 @@
>  				  unsigned int buflen)
>  {
>  	u8 *scsicmd = args->cmd->cmnd, *p, *last;
> -	unsigned int page_control, six_byte, output_len;
> +	const u8 sat_blk_desc[] = {0, 0, 0, 0, 0, 0, 0x2, 0x0};
> +	/* 512 byte blocks, number of blocks = 0, (sat-r05) */
> +	u8 pg, spg;
> +	unsigned int ebd, page_control, six_byte, output_len, alloc_len, minlen;
>  
>  	VPRINTK("ENTER\n");
>  
>  	six_byte = (scsicmd[0] == MODE_SENSE);
> +	ebd = !(scsicmd[1] & 0x8);	/* dbd bit inverted == edb */
>  
> -	/* we only support saved and current values (which we treat
> -	 * in the same manner)
> +	/*
> +	 * LLBA bit in MS(10) ignored (permitted)
> +	 * Only support current values (sat-r05)
>  	 */
>  	page_control = scsicmd[2] >> 6;
> -	if ((page_control != 0) && (page_control != 3))
> -		return 1;
> +	if (page_control != 0) {
> +		if (page_control == 3) {
> +			ata_scsi_set_sense(args->cmd,
> +					   ILLEGAL_REQUEST, 0x39, 0x0);
> +			/* "Saving parameters not supported" */
> +			return 2;
> +		} else
> +			return 1;
> +	}

[style] I would probably use a 'switch' statement here


> @@ -1237,6 +1369,151 @@
>  }
>  
>  /**
> + *	ata_scsi_mode_select_xlat - Translate SCSI MODE SELECT commands
> + *	@qc: Storage for translated ATA taskfile
> + *	@scsicmd: SCSI command to translate
> + *
> + *	Sets up an ATA taskfile to issue SET FEATURES, if required.
> + *
> + *	LOCKING:
> + *	spin_lock_irqsave(host_set lock)
> + *
> + *	RETURNS:
> + *	Zero on success, non-zero on error.
> + */
> +
> +static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc,
> +					      u8 *scsicmd)
> +{
> +	struct ata_taskfile *tf = &qc->tf;
> +	struct scsi_cmnd *cmd = qc->scsicmd;
> +	unsigned int param_len, ten, buflen, minlen, bdlen, offset;
> +	unsigned int pglen, spf, mpg, wce, dra;
> +	u8 *rbuf;
> +	u8 apage[48];

Overall, add some blank lines to the code below, to break it up a bit. 
Suggested places to break up code into "paragraphs" include 'return' 
statements or 'if' tests with long stretches of code inside.


> +	tf->flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
> +	tf->protocol = ATA_PROT_NODATA;
> +	cmd->result = SAM_STAT_GOOD;
> +	if (! (scsicmd[1] & 0x10))
> +		return 1;	/* require PF bit set */
> +	ten = (scsicmd[0] == MODE_SELECT_10) ? 1 : 0;
> +	param_len =  ten ? ((scsicmd[7] << 8) + scsicmd[8]) : scsicmd[4];
> +	if (param_len < (ten ? 8 : 4))
> +		return 2;
> +        buflen = ata_scsi_rbuf_get(cmd, &rbuf);

indentation problem

> +	minlen = (param_len < buflen) ? param_len : buflen;
> +	bdlen = ten ? ((rbuf[6] << 8) + rbuf[7]) : rbuf[3];
> +	offset = (ten ? 8 : 4) + bdlen;
> +	if (minlen > offset) {
> +		memset(apage, 0, sizeof(apage));
> +		pglen = minlen - offset;
> +		pglen = (pglen < sizeof(apage)) ? pglen : sizeof(apage);
> +		memcpy(apage, rbuf + offset, pglen);
> +	}
> +	ata_scsi_rbuf_put(cmd, rbuf);
> +	if (minlen == offset)
> +		return 2;
> +	if (minlen < offset)
> +		goto bad_param;
> +	minlen -= offset;
> +	spf = !!(apage[0] & 0x40);

'!!' operation not needed.


> +	mpg = apage[0] & 0x3f;
> +	/* mspg = spf ? apage[1] : 0; */
> +	if (spf)
> +		goto bad_param;
> +	else
> +		pglen = apage[1];
> +		if (pglen + 2 < minlen)
> +			goto bad_param;
> +	switch (mpg) {
> +	case 0x1:
> +		if (pglen != def_rw_recovery_mpage[1])
> +			goto bad_param;
> +		break;
> +	case 0x8:
> +		if (pglen != def_caching_mpage[1])
> +			goto bad_param;
> +		wce = !!(apage[2] & 0x4);
> +		dra = !!(apage[12] & 0x20);
> +		if (wce != !!(ata_id_wcache_enabled(qc->dev->id))) {
> +			/* write(back) cache */
> +			if (wce)
> +				tf->feature = 0x2;	/* WCE -> enable */
> +			else
> +				tf->feature = 0x82;	/* disable */

define named constants for these numeric constants, include/linux/ata.h


> +			tf->command = ATA_CMD_SET_FEATURES;
> +			/* <<< If success, should dev->id be updated? >>> */
> +			/* vvvvvvv   start of dubious code   vvvvvvvvvv */
> +			if (wce)
> +				qc->dev->id[85] |= 0x20;
> +			else
> +				qc->dev->id[85] &= ~0x20;
> +			/* vvvvvvv   end of dubious code   vvvvvvvvvv */
> +			return 0;

SET FEATURES should be followed by a second command, IDENTIFY [PACKET] 
DEVICE, to update dev->id and also to verify that the device set the 
feature as requested.


> +/* FIXME: we may want to issue two SET FEATURES commands here */
> +		if (dra != !(ata_id_rahead_enabled(qc->dev->id))) {

bug: need one more '!' AFAICS


> +			/* read look ahead */
> +			if (dra)
> +				tf->feature = 0x55;	/* DRA -> disable */
> +			else
> +				tf->feature = 0xaa;	/* enable */
> +			tf->command = ATA_CMD_SET_FEATURES;
> +			/* <<< If success, should dev->id be updated? >>> */
> +			/* vvvvvvv   start of dubious code   vvvvvvvvvv */
> +			if (dra)
> +				qc->dev->id[85] &= ~0x40;
> +			else
> +				qc->dev->id[85] |= 0x40;
> +			/* vvvvvvv   end of dubious code   vvvvvvvvvv */
> +			return 0;

same comment as with 'wce'.  if both dra and wce change, then four 
commands should follow: SET FEATURES, IDENTIFY DEVICE, SET FEATURES, 
IDENTIFY DEVICE.  If you wanted to be optimal, you could expend more 
[code] effort and only issue SF, SF, ID.


> +	case 0xa:
> +		if (pglen != def_control_mpage[1])
> +			goto bad_param;
> +		break;
> +	default:
> +		goto bad_param;
> +	}
> +	/* GOOD response, no ATA command issued */
> +	return 2;
> +
> +bad_param:
> +	ata_scsi_set_sense(cmd, ILLEGAL_REQUEST, 0x26, 0x0);
> +	/* "Invalid field in parameter list" */
> +	return 2;
> +}
> +
> +/**
> + *	ata_scsi_set_sense - Set SCSI sense data and status
> + *	@cmd: SCSI request to be handled
> + *	@sk: SCSI-defined sense key
> + *	@asc: SCSI-defined additional sense code
> + *	@ascq: SCSI-defined additional sense code qualifier
> + *
> + *	Helper function that builds a valid fixed format, current
> + *	response code and the given sense key (sk), additional sense
> + *	code (asc) and additional sense code qualifier (ascq) with
> + *	a SCSI command status of %SAM_STAT_CHECK_CONDITION .
> + *
> + *	LOCKING:
> + *	Not required
> + */
> +
> +void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
> +{
> +	cmd->result = SAM_STAT_CHECK_CONDITION;
> +
> +	cmd->sense_buffer[0] = 0x70;	/* fixed format, current */
> +	cmd->sense_buffer[2] = sk;
> +	cmd->sense_buffer[7] = 18 - 8;	/* additional sense length */
> +	cmd->sense_buffer[12] = asc;
> +	cmd->sense_buffer[13] = ascq;
> +}
> +
> +/**
>   *	ata_scsi_badcmd - End a SCSI request with an error
>   *	@cmd: SCSI request to be handled
>   *	@done: SCSI command completion function
> @@ -1254,13 +1531,7 @@
>  void ata_scsi_badcmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *), u8 asc, u8 ascq)
>  {
>  	DPRINTK("ENTER\n");
> -	cmd->result = SAM_STAT_CHECK_CONDITION;
> -
> -	cmd->sense_buffer[0] = 0x70;
> -	cmd->sense_buffer[2] = ILLEGAL_REQUEST;
> -	cmd->sense_buffer[7] = 14 - 8;	/* addnl. sense len. FIXME: correct? */
> -	cmd->sense_buffer[12] = asc;
> -	cmd->sense_buffer[13] = ascq;
> +	ata_scsi_set_sense(cmd, ILLEGAL_REQUEST, asc, ascq);
>  
>  	done(cmd);
>  }
> @@ -1414,9 +1685,10 @@
>   *	Pointer to translation function if possible, %NULL if not.
>   */
>  
> -static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
> +static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev,
> +						u8 *cmd)
>  {
> -	switch (cmd) {
> +	switch (cmd[0]) {
>  	case READ_6:
>  	case READ_10:
>  	case READ_16:
> @@ -1426,6 +1698,16 @@
>  	case WRITE_16:
>  		return ata_scsi_rw_xlat;
>  
> +	case INQUIRY:
> +		if (((cmd[1] & 0x3) == 0x1) && (cmd[2] == 0x89)) {

what do these magic numbers indicate?


> +			/* needs to re-issue an ATA IDENTIFY cmd
> +			 * and refill dev->id array. Then put this
> +			 * data and the signature in the vpd response.
> +			 */
> +			/* return ata_scsi_ata_info_vpd_xlat; ?? */

IFF your diagnosis is correct, then I agree with the proposed solution.

The rest looks OK.

	Jeff



