From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] sg.c to set direction more reliably  (was Re: [PATCH]
 fusion update to current APIs)
Date: Tue, 15 Jun 2004 02:54:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40CE9D31.6050606@pobox.com>
References: <20040531115229.GA16143@lst.de> <20040612003608.GA152454@sgi.com> <20040612034518.GN24864@parcelfarce.linux.theplanet.co.uk> <20040612051353.GA152829@sgi.com> <20040612052003.GR24864@parcelfarce.linux.theplanet.co.uk> <20040615060811.GA178857@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:5051 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265341AbUFOGzI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 02:55:08 -0400
In-Reply-To: <20040615060811.GA178857@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, Emoore@lsil.com, linux-scsi@vger.kernel.org

Jeremy Higdon wrote:
> +static int
> +sg_direction(char *cmnd)
> +{
> +	switch (cmnd[0]) {
> +	/*  _DATA_OUT commands	*/
> +	case WRITE_6:		case WRITE_10:		case WRITE_12:
> +	case WRITE_16:
> +	case WRITE_LONG:	case WRITE_SAME:	case WRITE_BUFFER:
> +	case WRITE_VERIFY:	case WRITE_VERIFY_12:
> +	case COMPARE:		case COPY:		case COPY_VERIFY:
> +	case SEARCH_EQUAL:	case SEARCH_HIGH:	case SEARCH_LOW:
> +	case SEARCH_EQUAL_12:	case SEARCH_HIGH_12:	case SEARCH_LOW_12:
> +	case MODE_SELECT:	case MODE_SELECT_10:	case LOG_SELECT:
> +	case SEND_DIAGNOSTIC:	case CHANGE_DEFINITION: case UPDATE_BLOCK:
> +	case SET_WINDOW:	case MEDIUM_SCAN:	case SEND_VOLUME_TAG:
> +	case REASSIGN_BLOCKS:
> +	case PERSISTENT_RESERVE_OUT:
> +	case 0xea:
> +	case 0xa3:
> +		return SG_DXFER_TO_DEV;
> +
> +	/*  No data transfer commands  */
> +	case SEEK_6:		case SEEK_10:
> +	case RESERVE:		case RELEASE:
> +	case TEST_UNIT_READY:
> +	case START_STOP:
> +	case ALLOW_MEDIUM_REMOVAL:
> +		return SG_DXFER_NONE;
> +
> +	/*  Conditional data transfer commands	*/
> +	case FORMAT_UNIT:
> +		if (cmnd[1] & 0x10)	/* FmtData (data out phase)? */
> +			return SG_DXFER_TO_DEV;
> +		else
> +			return SG_DXFER_NONE;
> +
> +	case VERIFY:
> +		if (cmnd[1] & 0x02)	/* VERIFY:BYTCHK (data out phase)? */
> +			return SG_DXFER_TO_DEV;
> +		else
> +			return SG_DXFER_NONE;
> +
> +	case RESERVE_10:
> +		if (cmnd[1] & 0x03)  /* RESERVE:{LongID|Extent} (data out phase)? */
> +			return SG_DXFER_TO_DEV;
> +		else
> +			return SG_DXFER_NONE;
> +
> +	/*  Must be data _IN!  */
> +	default:
> +		return SG_DXFER_FROM_DEV;
> +	}
> +}


This is definitely moving backwards from the direction we want to go.

The entity creating the SCSI command needs to specify data direction, 
_not_ tables hardcoded into the kernel.  Bart recently removed such a 
table from IDE.

These tables are fundamentally broken anyway, due to vendor-reserved 
commands where the data directions are not specified, but simply "known" 
by the submittor.

If /dev/sg's userland interface does not permit userland to provide the 
data direction, then let's just consider it broken and move to Axboe's 
bsg post-haste.

	Jeff


