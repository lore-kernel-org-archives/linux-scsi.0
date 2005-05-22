From: Douglas Gilbert <dougg@torque.net>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Sun, 22 May 2005 16:31:26 +1000
Message-ID: <4290273E.6050306@torque.net>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:9870 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261727AbVEVGbV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 May 2005 02:31:21 -0400
In-Reply-To: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, jgarzik@pobox.com

Al + James,
Some comments about the original patch:

<snip>
> diff -urN RC12-rc4-base/drivers/scsi/sd.c RC12-rc4-rbc/drivers/scsi/sd.c
> --- RC12-rc4-base/drivers/scsi/sd.c	2005-05-07 04:05:00.000000000 -0400
> +++ RC12-rc4-rbc/drivers/scsi/sd.c	2005-05-15 12:30:38.769387199 -0400
> @@ -1368,17 +1368,26 @@
>   */
>  static void
>  sd_read_cache_type(struct scsi_disk *sdkp, char *diskname,
> -		   struct scsi_request *SRpnt, unsigned char *buffer) {
> +		   struct scsi_request *SRpnt, unsigned char *buffer)
> +{
>  	int len = 0, res;
>  
> -	const int dbd = 0;	   /* DBD */
> -	const int modepage = 0x08; /* current values, cache page */
> +	int dbd;
> +	int modepage;
>  	struct scsi_mode_data data;
>  	struct scsi_sense_hdr sshdr;
>  
>  	if (sdkp->device->skip_ms_page_8)
>  		goto defaults;
>  
> +	if (sdkp->device->type == TYPE_RBC) {
> +		modepage = 6;
> +		dbd = 8;

Al,
In my experience setting the DBD flag only increases the
chance of failure (from devices that don't understand the
DBD (i.e. disable block descriptors) bit. Also dbd should
be set (to 1) or cleared; not set to 8. Best to leave it clear
(the default) as the offset calculation below takes into
account any returned block descriptors.

James,
scsi_lib.c::__scsi_mode_sense() has a bug in it.
If dbd is set then both the DBD and LLBA bits in the
MODE SENSE cdb are set. However LLBA is not defined for
MODE SENSE 6 (in SPC or RBC). That may be why Al's
hardware doesn't like MODE SENSE 6 cdbs issued by the
SCSI mid level :-)

> +	} else {
> +		modepage = 8;
> +		dbd = 0;
> +	}
> +
>  	/* cautiously ask */
>  	res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, 4, &data);
>  
> @@ -1409,11 +1418,20 @@
>  			"write back, no read (daft)"
>  		};
>  		int ct = 0;
> -		int offset = data.header_length +
> -			data.block_descriptor_length + 2;
> +		int offset = data.header_length + data.block_descriptor_length;
>  
> -		sdkp->WCE = ((buffer[offset] & 0x04) != 0);
> -		sdkp->RCD = ((buffer[offset] & 0x01) != 0);
> +		if ((buffer[offset] & 0x3f) != modepage) {
> +			printk(KERN_ERR "%s: got wrong page\n", diskname);
> +			goto defaults;
> +		}

So here is the sanity check that I have been talking
about. On my hardware since a MODE SENSE 10 was issued,
the response is corrupt (actually the response for the
corresponding MODE SENSE 6 is returned) so the exercise
becomes futile. Note that my hardware complies with
the RBC standard in properly supporting MODE SENSE 6.
[The RBC standard doesn't say anything about what should
happen when MODE SENSE 10 is issued :-)]

To work on my hardware the next move would be to
"sdev->use_10_for_ms = 0;" and try again (and if
that fails give up).

<snip>

Doug Gilbert
