From: James Smart <james.smart@emulex.com>
Subject: Re: lpfc: Unknown ELS command x18 received from NPORT xfffc2b
Date: Sat, 18 Apr 2015 11:41:50 -0400
Message-ID: <55327B3E.7090406@emulex.com>
References: <20150415010757.00007ad1@localhost>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:19067 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbbDRPlw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Apr 2015 11:41:52 -0400
In-Reply-To: <20150415010757.00007ad1@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: linux-scsi@vger.kernel.org

This would silence it. However, I'm about to push a new patch set which 
adds full RDP support.

-- james s


On 4/14/2015 7:07 PM, Sebastian Herbszt wrote:
> We recently started to get
>
> [8043768.238110] lpfc 0000:10:00.1: 1:(0):0115 Unknown ELS command x18 received from NPORT xfffc2b
> [8130462.560283] lpfc 0000:10:00.1: 1:(0):0115 Unknown ELS command x18 received from NPORT xfffc2b
> [8216439.442882] lpfc 0000:10:00.1: 1:(0):0115 Unknown ELS command x18 received from NPORT xfffc2b
>
> Read Diagnostic Parameters (RDP) [1] support was introduced in Brocade Fabric OS 7.3 [2].
>
> The following (untested) patch might silence the message.
>
> [1] http://www.t11.org/ftp/t11/pub/fc/ls-3/14-033v0.pdf
> [2] ftp://public.dhe.ibm.com/storage/san/fos7/v7.3.0c_ReleaseNotes_v1.0.pdf
>
> Sebastian
>
>
> diff -uNrp v4.0-1941-geeee78c/drivers/scsi/lpfc.orig/lpfc_els.c v4.0-1941-geeee78c/drivers/scsi/lpfc/lpfc_els.c
> --- v4.0-1941-geeee78c/drivers/scsi/lpfc.orig/lpfc_els.c	2015-02-12 01:04:08.692134956 +0100
> +++ v4.0-1941-geeee78c/drivers/scsi/lpfc/lpfc_els.c	2015-04-14 21:44:31.591639045 +0200
> @@ -6970,6 +6970,10 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
>   			rjt_err = LSRJT_UNABLE_TPC;
>   			rjt_exp = LSEXP_INVALID_OX_RX;
>   		break;
> +	case ELS_CMD_RDP:
> +		rjt_err = LSRJT_UNABLE_TPC;
> +		rjt_exp = LSEXP_REQ_UNSUPPORTED;
> +		break;
>   	default:
>   		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
>   			"RCV ELS cmd:     cmd:x%x did:x%x/ste:x%x",
> diff -uNrp v4.0-1941-geeee78c/drivers/scsi/lpfc.orig/lpfc_hw.h v4.0-1941-geeee78c/drivers/scsi/lpfc/lpfc_hw.h
> --- v4.0-1941-geeee78c/drivers/scsi/lpfc.orig/lpfc_hw.h	2014-09-03 19:30:11.768273300 +0200
> +++ v4.0-1941-geeee78c/drivers/scsi/lpfc/lpfc_hw.h	2015-04-14 21:18:10.039566920 +0200
> @@ -540,6 +540,7 @@ struct fc_vft_header {
>   #define ELS_CMD_TEST      0x11000000
>   #define ELS_CMD_RRQ       0x12000000
>   #define ELS_CMD_REC       0x13000000
> +#define ELS_CMD_RDP       0x18000000
>   #define ELS_CMD_PRLI      0x20100014
>   #define ELS_CMD_PRLO      0x21100014
>   #define ELS_CMD_PRLO_ACC  0x02100014
> @@ -577,6 +578,7 @@ struct fc_vft_header {
>   #define ELS_CMD_TEST      0x11
>   #define ELS_CMD_RRQ       0x12
>   #define ELS_CMD_REC       0x13
> +#define ELS_CMD_RDP       0x18
>   #define ELS_CMD_PRLI      0x14001020
>   #define ELS_CMD_PRLO      0x14001021
>   #define ELS_CMD_PRLO_ACC  0x14001002
>
>

