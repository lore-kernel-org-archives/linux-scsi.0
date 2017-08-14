From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 1/2] nvmet_fc: add defer_req callback for deferment of
 cmd buffer return
Date: Mon, 14 Aug 2017 14:16:49 +0000
Message-ID: <CY1PR0401MB15363E9796381A376013E71C988C0@CY1PR0401MB1536.namprd04.prod.outlook.com>
References: <20170805002933.23397-1-jsmart2021@gmail.com>
 <20170805002933.23397-2-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:57378 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751428AbdHNORh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2017 10:17:37 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Smart <james.smart@broadcom.com>

On 08/04/17 17:29, James Smart wrote:=0A=
> +	/* Cleanup defer'ed IOs in queue */=0A=
> +	list_for_each_entry(deferfcp, &queue->avail_defer_list, req_list) {=0A=
> +		list_del(&deferfcp->req_list);=0A=
> +		kfree(deferfcp);=0A=
> +	}=0A=
=0A=
Hello James,=0A=
=0A=
Coverity reports a user-after-free for the above code:=0A=
=0A=
*** CID 1416424:  Memory - illegal accesses  (USE_AFTER_FREE)=0A=
/drivers/nvme/target/fc.c: 738 in nvmet_fc_delete_target_queue()=0A=
732     					&tgtport->fc_target_port, fod->fcpreq);=0A=
733     			}=0A=
734     		}=0A=
735     	}=0A=
736     =0A=
737     	/* Cleanup defer'ed IOs in queue */=0A=
>>>     CID 1416424:  Memory - illegal accesses  (USE_AFTER_FREE)=0A=
>>>     Dereferencing freed pointer "deferfcp".=0A=
738     	list_for_each_entry(deferfcp, &queue->avail_defer_list, req_list) =
{=0A=
739     		list_del(&deferfcp->req_list);=0A=
740     		kfree(deferfcp);=0A=
741     	}=0A=
742     =0A=
743     	for (;;) {=0A=
