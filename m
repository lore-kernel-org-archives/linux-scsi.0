From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 9/13] nsp32, nsp_cs driver update
Date: Mon, 28 Feb 2005 19:10:12 +0200
Message-ID: <1109610612.5330.2.camel@mulgrave>
References: <20050222.161158.59718314.yokota@netlab.is.tsukuba.ac.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:4283 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261748AbVB1V2T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2005 16:28:19 -0500
In-Reply-To: <20050222.161158.59718314.yokota@netlab.is.tsukuba.ac.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yokota Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-02-22 at 16:11 +0900, Yokota Hiroshi wrote:
> +	if (data->CurrentSC     != NULL) {
> +		nsp_msg(KERN_WARNING, "CurrentSC!=NULL this can't be happen");
>  		SCpnt->result   = DID_BAD_TARGET << 16;
>  		nsp_scsi_done(SCpnt);
> -		return 0;
> +		return SCSI_MLQUEUE_HOST_BUSY;
>  	}


This looks wrong.  Either you call done on the command or you return
busy.  If you do both, the command will be completed twice.  There seem
to be a lot of other places where the driver will call done then return
BUSY too ...

James


