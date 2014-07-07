From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] qla4xxx: Return -ENOMEM on memory allocation failure
Date: Mon, 07 Jul 2014 11:31:06 -0500
Message-ID: <53BACB4A.7080706@cs.wisc.edu>
References: <20140704182756.GA9319@himangi-Dell> <94D0CD8314A33A4D9D801C0FE68B402958B866EB@G9W0745.americas.hpqcorp.net> <alpine.DEB.2.02.1407042235390.1984@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60611 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaGGQcF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2014 12:32:05 -0400
In-Reply-To: <alpine.DEB.2.02.1407042235390.1984@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Himangi Saraogi <himangi774@gmail.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, "iscsi-driver@qlogic.com" <iscsi-driver@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 07/04/2014 03:37 PM, Julia Lawall wrote:
> 
> 
> On Fri, 4 Jul 2014, Elliott, Robert (Server Storage) wrote:
> 
>>
>>
>>> -----Original Message-----
>>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>>> owner@vger.kernel.org] On Behalf Of Himangi Saraogi
>>> Sent: Friday, 04 July, 2014 1:28 PM
>>> To: Vikas Chaudhary; iscsi-driver@qlogic.com; James E.J. Bottomley; linux-
>>> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
>>> Cc: julia.lawall@lip6.fr
>>> Subject: [PATCH] qla4xxx: Return -ENOMEM on memory allocation failure
>>>
>>> In this code, 0 is returned on memory allocation failure, even though
>>> other failures return -ENOMEM or other similar values.
>>>
>>> A simplified version of the Coccinelle semantic match that finds this
>>> problem is as follows:
>>>
>>> // <smpl>
>>> @@
>>> expression ret;
>>> expression x,e1,e2,e3;
>>> identifier alloc;
>>> @@
>>>
>>> ret = 0
>>> ... when != ret = e1
>>> *x = alloc(...)
>>> ... when != ret = e2
>>> if (x == NULL) { ... when != ret = e3
>>>   return ret;
>>> }
>>> // </smpl>
>>>
>>> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
>>> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
>>> ---
>>>  drivers/scsi/qla4xxx/ql4_os.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
>>> index c5d9564..72ba671 100644
>>> --- a/drivers/scsi/qla4xxx/ql4_os.c
>>> +++ b/drivers/scsi/qla4xxx/ql4_os.c
>>> @@ -1050,6 +1050,7 @@ static int qla4xxx_get_host_stats(struct Scsi_Host
>>> *shost, char *buf, int len)
>>>  	if (!ql_iscsi_stats) {
>>>  		ql4_printk(KERN_ERR, ha,
>>>  			   "Unable to allocate memory for iscsi stats\n");
>>> +		ret = -ENOMEM;
>>>  		goto exit_host_stats;
>>>  	}
>>>
>>
>> Also, the only caller of this function doesn't use the return 
>> value - it's overwritten by another function call:
>>
>> drivers/scsi/scsi_transport_iscsi.c:
>>                 err = transport->get_host_stats(shost, buf, host_stats_size);
>>
>>                 actual_size = nlmsg_total_size(sizeof(*ev) + host_stats_size);
>>                 skb_trim(skbhost_stats, NLMSG_ALIGN(actual_size));
>>                 nlhhost_stats->nlmsg_len = actual_size;
>>
>>                 err = iscsi_multicast_skb(skbhost_stats, ISCSI_NL_GRP_ISCSID,
>>                                           GFP_KERNEL);
> 
> Maybe that is intentional?

I think it was a mistake. There is also one more issue in
qla4xxx_get_host_stats where it is returning an internal qlogic
specific error value. This patch should fix all issues.


[PATCH] qla4xxx/iscsi: fix get_host_stats error propagation

This patch fixes 2 bugs.

1. qla4xxx was not always returning -EXYZ error codes when
qla4xxx_get_host_stats failed.

2. iscsi_get_host_stats was dropping the error code returned
by drivers like qla4xxx.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 459b9f7..e4dc3e0 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1050,6 +1050,7 @@ static int qla4xxx_get_host_stats(struct Scsi_Host *shost, char *buf, int len)
 	if (!ql_iscsi_stats) {
 		ql4_printk(KERN_ERR, ha,
 			   "Unable to allocate memory for iscsi stats\n");
+		ret = -ENOMEM;
 		goto exit_host_stats;
 	}
 
@@ -1058,6 +1059,7 @@ static int qla4xxx_get_host_stats(struct Scsi_Host *shost, char *buf, int len)
 	if (ret != QLA_SUCCESS) {
 		ql4_printk(KERN_ERR, ha,
 			   "Unable to retrieve iscsi stats\n");
+		ret = -EIO;
 		goto exit_host_stats;
 	}
 	host_stats->mactx_frames = le64_to_cpu(ql_iscsi_stats->mac_tx_frames);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 0102a2d..ea2996a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3467,6 +3467,10 @@ iscsi_get_host_stats(struct iscsi_transport *transport, struct nlmsghdr *nlh)
 		memset(buf, 0, host_stats_size);
 
 		err = transport->get_host_stats(shost, buf, host_stats_size);
+		if (err) {
+			kfree(skbhost_stats);
+			goto exit_host_stats;
+		}
 
 		actual_size = nlmsg_total_size(sizeof(*ev) + host_stats_size);
 		skb_trim(skbhost_stats, NLMSG_ALIGN(actual_size));

