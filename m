From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: Re: [PATCH] qla2xxx: support for multi- queue adapter
Date: Tue, 16 Dec 2008 17:41:52 -0800 (PST)
Message-ID: <alpine.OSX.1.00.0812161738510.19084@ac-mac.local>
References: <alpine.OSX.1.00.0812091525020.9629@ac-mac.local> <20081216194745.GA20277@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:1401 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbYLQBl5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Dec 2008 20:41:57 -0500
In-Reply-To: <20081216194745.GA20277@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Driver <Linux-Driver@qlogic.com>



On Tue, 16 Dec 2008, Dave Jones wrote:

> On Tue, Dec 09, 2008 at 04:45:39PM -0800, Anirban Chakraborty wrote:
>   > +	memset(vha->req_ques, sizeof(vha->req_ques) * QLA_MAX_HOST_QUES, 0);
> 
> ITYM
> 
> +       memset(vha->req_ques, 0, sizeof(vha->req_ques) * QLA_MAX_HOST_QUES);
> 
>         Dave

Sorry about that. Thanks for pointing it out.
Please apply,

Anirban

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

---
 drivers/scsi/qla2xxx/qla_mid.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 55730f4..386ffea 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -396,7 +396,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 
 	qla2x00_start_timer(vha, qla2x00_timer, WATCH_INTERVAL);
 
-	memset(vha->req_ques, sizeof(vha->req_ques) * QLA_MAX_HOST_QUES, 0);
+	memset(vha->req_ques, 0, sizeof(vha->req_ques) * QLA_MAX_HOST_QUES);
 	vha->req_ques[0] = ha->req_q_map[0]->id;
 	host->can_queue = ha->req_q_map[0]->length + 128;
 	host->this_id = 255;

