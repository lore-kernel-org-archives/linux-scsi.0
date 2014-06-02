From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/6] [SCSI] Look up and store NAA if VPD page 0x83 is
 present
Date: Mon, 02 Jun 2014 22:59:33 +0200
Message-ID: <538CE5B5.7030407@redhat.com>
References: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com> <1401335565-29865-6-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41054 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaFBU7h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 16:59:37 -0400
Received: by mail-we0-f174.google.com with SMTP id k48so5898283wev.33
        for <linux-scsi@vger.kernel.org>; Mon, 02 Jun 2014 13:59:36 -0700 (PDT)
In-Reply-To: <1401335565-29865-6-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

Il 29/05/2014 05:52, Martin K. Petersen ha scritto:
> +	sdev_printk(KERN_ERR, sdev,
> +		    "%s: VPD page 0x83 NAA descriptor not found\n", __func__);
> +
> +	return;

I suspect this error will be relatively common.

libata for example has

        if (ata_id_has_wwn(args->id)) {
                /* SAT defined lu world wide name */
                /* piv=0, assoc=lu, code_set=binary, designator=NAA */
                rbuf[num + 0] = 1;
                rbuf[num + 1] = 3;
                rbuf[num + 3] = ATA_ID_WWN_LEN;
                num += 4;
                ata_id_string(args->id, (unsigned char *) rbuf + num,
                              ATA_ID_WWN, ATA_ID_WWN_LEN);
                num += ATA_ID_WWN_LEN;
        }
        rbuf[3] = num - 4;    /* page len (assume less than 256 bytes) */

and most of the time IDE disks in a virtual machine are configured without
a WWN.

Paolo
