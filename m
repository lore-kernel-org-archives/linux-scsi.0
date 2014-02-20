From: James Smart <james.smart@emulex.com>
Subject: Re: suspicious self-assignment in lpfc
Date: Thu, 20 Feb 2014 14:19:21 -0500
Message-ID: <53065539.4040704@emulex.com>
References: <20140218174211.GA17778@redhat.com>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:15014 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbaBTTTX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 14:19:23 -0500
In-Reply-To: <20140218174211.GA17778@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: linux-scsi@vger.kernel.org

yeah - this is pretty silly.  I'll cut a patch to remove the lines.

-- james s


On 2/18/2014 12:42 PM, Dave Jones wrote:
> Looking through coverity reports, and it flagged lpfc_read_fcf_conn_tbl()
> due to the following patch..
>
> commit df0d085fdd2e7c39d1249c2d4ad6b3e176efb60c
> Author: James Smart <james.smart@emulex.com>
> Date:   Fri May 31 17:05:08 2013 -0400
>
>      [SCSI] lpfc 8.3.40: Fixed FCoE connection list vlan identifier and add FCF list debug
>      
>      Signed-off-by: James Smart <james.smart@emulex.com>
>      Signed-off-by: James Bottomley <JBottomley@Parallels.com>
>
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index 0f6e2548f35d..0309cc15aad6 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -6158,12 +6158,44 @@ lpfc_read_fcf_conn_tbl(struct lpfc_hba *phba,
>                  memcpy(&conn_entry->conn_rec, &conn_rec[i],
>                          sizeof(struct lpfc_fcf_conn_rec));
>                  conn_entry->conn_rec.vlan_tag =
> -                       le16_to_cpu(conn_entry->conn_rec.vlan_tag) & 0xFFF;
> +                       conn_entry->conn_rec.vlan_tag;
>                  conn_entry->conn_rec.flags =
> -                       le16_to_cpu(conn_entry->conn_rec.flags);
> +                       conn_entry->conn_rec.flags;
>                  list_add_tail(&conn_entry->list,
>                          &phba->fcf_conn_rec_list);
>
>
> Now that we're not caring about endianness, those two assignments are redundant.
> I gather this has passed testing, because surely someone would have complained by now,
> but can they be removed, or should they be doing something else entirely ?
>
> 	Dave
>
>
>

