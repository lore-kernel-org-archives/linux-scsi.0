Return-Path: <SRS0=rQSi=EH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2BAC4741F
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Nov 2020 22:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68D17222B9
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Nov 2020 22:06:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RNuwGvdI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbgKAWGf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Nov 2020 17:06:35 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:57008 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbgKAWGe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Nov 2020 17:06:34 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A1M4l3L056572;
        Sun, 1 Nov 2020 22:06:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=D1bsWNhuFXNhBxICGWeC1VrJILaWeRWhjLBt44jMKkM=;
 b=RNuwGvdIXY9evDQBjAuVbzURFJvKU+1ZA5cMVbgMWFimsc0NQ3ayQYa00kZ5e4eSSK1h
 g2HkbkMBjSSYmZAbDykpxF/00+2iefMXu+KUy73uo1WpzjNEShhqe5JzIl8h371PtE7N
 RjMkdjtQl96kb7iV1imZ93eXA1T5iIsDdMVErD9U5d6k6hz84u/QwsX6NGyLrD+m4RAk
 B/oyoQ0744ewjj+QDtx2/6U2IfsYK4Q1m/AoVfq7aHtWD5x/xrMm2Y9bm3wH2uvmCLzZ
 S2KSYcb28jdww7wKKHPkcZzx4NP3v6A5c6EpqGl13xNUYwRJP4WdySAZqVv/wcjH3uDm sg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34hhw29h27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 01 Nov 2020 22:06:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A1M0Kvd159775;
        Sun, 1 Nov 2020 22:06:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34hw0e8r4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Nov 2020 22:06:26 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A1M6Bro022246;
        Sun, 1 Nov 2020 22:06:13 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 01 Nov 2020 14:06:11 -0800
Subject: Re: [PATCH 07/17] vhost scsi: support delayed IO vq creation
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-8-git-send-email-michael.christie@oracle.com>
 <9e97ea2a-bc57-d4aa-4711-35dba20b3b9e@redhat.com>
 <49c2fc29-348c-06db-4823-392f7476d318@oracle.com>
 <20201030044402-mutt-send-email-mst@kernel.org>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <292879d9-915d-8587-0678-8677a800c613@oracle.com>
Date:   Sun, 1 Nov 2020 16:06:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201030044402-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9792 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011010180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9792 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011010180
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/30/20 3:47 AM, Michael S. Tsirkin wrote:
> On Tue, Oct 27, 2020 at 12:47:34AM -0500, Mike Christie wrote:
>> On 10/25/20 10:51 PM, Jason Wang wrote:
>>>
>>> On 2020/10/22 上午8:34, Mike Christie wrote:
>>>> Each vhost-scsi device will need a evt and ctl queue, but the number
>>>> of IO queues depends on whatever the user has configured in userspace.
>>>> This patch has vhost-scsi create the evt, ctl and one IO vq at device
>>>> open time. We then create the other IO vqs when userspace starts to
>>>> set them up. We still waste some mem on the vq and scsi vq structs,
>>>> but we don't waste mem on iovec related arrays and for later patches
>>>> we know which queues are used by the dev->nvqs value.
>>>>
>>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>>> ---
>>>>   drivers/vhost/scsi.c | 19 +++++++++++++++----
>>>>   1 file changed, 15 insertions(+), 4 deletions(-)
>>>
>>>
>>> Not familiar with SCSI. But I wonder if it could behave like vhost-net.
>>>
>>> E.g userspace should known the number of virtqueues so it can just open
>>> and close multiple vhost-scsi file descriptors.
>>>
>>
>> One hiccup I'm hitting is that we might end up creating about 3x more vqs
>> than we need. The problem is that for scsi each vhost device has:
>>
>> vq=0: special control vq
>> vq=1: event vq
>> vq=2 and above: SCSI CMD/IO vqs. We want to create N of these.
>>
>> Today we do:
>>
>> Uerspace does open(/dev/vhost-scsi)
>>         vhost_dev_init(create 128 vqs and then later we setup and use N of
>> them);
>>
>> Qemu does ioctl(VHOST_SET_OWNER)
>>         vhost_dev_set_owner()
>>
>> For N vqs userspace does:
>>         // virtqueue setup related ioctls
>>
>> Qemu does ioctl(VHOST_SCSI_SET_ENDPOINT)
>>         - match LIO/target port to vhost_dev
>>
>>
>> So we could change that to:
>>
>> For N IO vqs userspace does
>>         open(/dev/vhost-scsi)
>>                 vhost_dev_init(create IO, evt, and ctl);
>>
>> for N IO vqs Qemu does:
>>         ioctl(VHOST_SET_OWNER)
>>                 vhost_dev_set_owner()
>>
>> for N IO vqs Qemu does:
>>         // virtqueue setup related ioctls
>>
>> for N IO vqs Qemu does:
>>         ioctl(VHOST_SCSI_SET_ENDPOINT)
>>                 - match LIO/target port to vhost_dev and assemble the
>> multiple vhost_dev device.
>>
>> The problem is that we have to setup some of the evt/ctl specific parts at
>> open() time when vhost_dev_init does vhost_poll_init for example.
>>
>> - At open time, we don't know if this vhost_dev is going to be part of a
>> multiple vhost_device device or a single one so we need to create at least 3
>> of them
>> - If it is a multiple device we don't know if its the first device being
>> created for the device or the N'th, so we don't know if the dev's vqs will
>> be used for IO or ctls/evts, so we have to create all 3.
>>
>> When we get the first VHOST_SCSI_SET_ENDPOINT call for a new style multiple
>> vhost_dev device, we can use that dev's evt/ctl vqs for events/controls
>> requests. When we get the other VHOST_SCSI_SET_ENDPOINT calls for the
>> multiple vhost_dev device then those dev's evt/ctl vqs will be ignored and
>> we will only use their IO vqs. So we end up with a lot of extra vqs.
> 
> The issue Jason's hinting at is how can admins control the amount
> of resources a given qemu instance can consume?
> After all vhost vqs all live in host kernel memory ...
> Limiting # of open fds would be one way to do that ...
> 
> The need to share event/control vqs between devices is a problem though,
> and sending lots of ioctls on things like reset is also not that elegant.
> Jason, did you have a good solution in mind?
> 

Hey, so here is a prototype/outline of how we could add support for the
multiple device approach and keep compat support for the existing single
device multiple vq code. And, for the new style multiple dev approach we
keep the vq allocation to a minimum.

This patch was made over patches 0 - 11 in this patchset, but do not waste
your time reviewing this patch line by line. It's still really broken :) It
should give you an idea of what I was saying above about the evt/ctl queue
issue and give you an idea of how ugly/nice it is vs the patches 12 - 16
in this set.

--------------

In this patch we add a new struct vhost_scsi_md that represents multiple
vhost_scsi devices that are being combined to make one device.

Userspace signals the kernel it supports the new md approach by writing to
a new mod param vhost_scsi_multi_dev_per_nexus. If that is set then at
open() scsi.c will do vhost_dev_init with 1 vq. The vq's handle_kick
function is a dummy no op (vhost_scsi_no_op_kick), because at this time we
don't know if this device's vq is going to be a evt, ctl or IO vq.

Userpsace would then do open() N times for each vq it wanted to create.

Qemu then does it's dev and ring/vq setup.

Lastly qemu does the ioctl that calls into vhost_scsi_set_endpoint. For this
function scsi has to figure out if it's a md device or old style one. If a md
device then we figure out which vq this will be in the new function
vhost_scsi_md_add_vs().

Here is where it gets a little gross. Because we don't know what type of
vq it is at vhost_dev_init/open time, I've added a new function
vhost_vq_reset_kick_handler which just resets the handle_kick callout
that we had setup in vhost_dev_init. We call this in vhost_scsi_md_add_vs
to set the correct handle_kick function.



diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 774bffe..f18f7b1 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -62,6 +62,12 @@
  */
 #define VHOST_SCSI_WEIGHT 256
 
+static bool vhost_scsi_multi_dev_per_nexus;
+module_param_named(multiple_vhost_devs_per_nexus,
+		   vhost_scsi_multi_dev_per_nexus, bool, 0644);
+MODULE_PARM_DESC(multiple_vhost_devs_per_nexus,
+		 "Turn on support for combing multiple vhost-scsi device instances into a single I_T Nexus. Set to true to turn on. Default is off.");
+
 struct vhost_scsi_inflight {
 	/* Wait for the flush operation to finish */
 	struct completion comp;
@@ -127,7 +133,7 @@ struct vhost_scsi_tpg {
 	int tv_tpg_vhost_count;
 	/* Used for enabling T10-PI with legacy devices */
 	int tv_fabric_prot_type;
-	/* list for vhost_scsi_list */
+	/* list for vhost_scsi_tpg_list */
 	struct list_head tv_tpg_list;
 	/* Used to protect access for tpg_nexus */
 	struct mutex tv_tpg_mutex;
@@ -137,7 +143,7 @@ struct vhost_scsi_tpg {
 	struct vhost_scsi_tport *tport;
 	/* Returned by vhost_scsi_make_tpg() */
 	struct se_portal_group se_tpg;
-	/* Pointer back to vhost_scsi, protected by tv_tpg_mutex */
+	/* Pointer back to vhost_scsi used for events, protected by tv_tpg_mutex */
 	struct vhost_scsi *vhost_scsi;
 	struct list_head tmf_queue;
 };
@@ -194,13 +200,22 @@ struct vhost_scsi_virtqueue {
 	int max_cmds;
 };
 
+struct vhost_scsi_md {
+	struct list_head vhost_scsi_md_list_entry;
+	struct list_head vhost_scsi_list;
+	int vs_cnt;
+};
+
 struct vhost_scsi {
 	/* Protected by vhost_scsi->dev.mutex */
 	struct vhost_scsi_tpg **vs_tpg;
+	struct list_head vhost_scsi_list_entry;
 	char vs_vhost_wwpn[TRANSPORT_IQN_LEN];
+	struct vhost_scsi_md *md;
+	bool md_enabled;
 
 	struct vhost_dev dev;
-	struct vhost_scsi_virtqueue vqs[VHOST_SCSI_MAX_VQ];
+	struct vhost_scsi_virtqueue *vqs;
 
 	struct vhost_work vs_completion_work; /* cmd completion work item */
 	struct llist_head vs_completion_list; /* cmd completion queue */
@@ -242,8 +257,11 @@ struct vhost_scsi_ctx {
 static struct workqueue_struct *vhost_scsi_workqueue;
 
 /* Global spinlock to protect vhost_scsi TPG list for vhost IOCTL access */
-static DEFINE_MUTEX(vhost_scsi_mutex);
-static LIST_HEAD(vhost_scsi_list);
+static DEFINE_MUTEX(vhost_scsi_tpg_mutex);
+static LIST_HEAD(vhost_scsi_tpg_list);
+
+/* List of multiple device (mq) devs accesed under the vhost_scsi_tpg_mutex */
+static LIST_HEAD(vhost_scsi_md_list);
 
 static void vhost_scsi_done_inflight(struct kref *kref)
 {
@@ -260,7 +278,7 @@ static void vhost_scsi_init_inflight(struct vhost_scsi *vs,
 	struct vhost_virtqueue *vq;
 	int idx, i;
 
-	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++) {
+	for (i = 0; i < vs->dev.max_nvqs; i++) {
 		vq = &vs->vqs[i].vq;
 
 		mutex_lock(&vq->mutex);
@@ -588,8 +606,7 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 	}
 
 	vq = -1;
-	while ((vq = find_next_bit(signal, VHOST_SCSI_MAX_VQ, vq + 1))
-		< VHOST_SCSI_MAX_VQ)
+	while ((vq = find_next_bit(signal, vs->dev.nvqs, vq + 1)) < vs->dev.nvqs)
 		vhost_signal(&vs->dev, &vs->vqs[vq].vq);
 }
 
@@ -1443,6 +1460,11 @@ static void vhost_scsi_handle_kick(struct vhost_work *work)
 	vhost_scsi_handle_vq(vs, vq);
 }
 
+static void vhost_scsi_no_op_kick(struct vhost_work *work)
+{
+	pr_err("Invalid no op kick call\n");
+}
+
 /* Callers must hold dev mutex */
 static void vhost_scsi_flush(struct vhost_scsi *vs)
 {
@@ -1457,14 +1479,14 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
 	 * indicate the start of the flush operation so that it will reach 0
 	 * when all the reqs are finished.
 	 */
-	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++)
+	for (i = 0; i < vs->dev.nvqs; i++)
 		kref_put(&old_inflight[i]->kref, vhost_scsi_done_inflight);
 
 	/* Flush both the vhost poll and vhost work */
 	vhost_work_dev_flush(&vs->dev);
 
 	/* Wait for all reqs issued before the flush to be finished */
-	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++)
+	for (i = 0; i < vs->dev.nvqs; i++)
 		wait_for_completion(&old_inflight[i]->comp);
 }
 
@@ -1545,12 +1567,87 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 	return -ENOMEM;
 }
 
+static void vhost_scsi_md_del_vs(struct vhost_scsi *vs)
+{
+	struct vhost_scsi_md *md;
+
+	if (!vs->md_enabled)
+		return;
+
+	if (list_empty(&vs->vhost_scsi_list_entry))
+		return;
+
+	md = vs->md;
+	vs->md = NULL;
+	md->vs_cnt--;
+	list_del_init(&vs->vhost_scsi_list_entry);
+
+	if (!md->vs_cnt) {
+		list_del(&md->vhost_scsi_md_list_entry);
+		kfree(md);
+	}
+}
+
+static int vhost_scsi_md_add_vs(struct vhost_scsi *vs,
+				struct vhost_scsi_target *tgt)
+{
+	struct vhost_scsi *lead_vs;
+	struct vhost_scsi_md *md;
+
+	if (!vs->md_enabled)
+		return 0;
+
+	if (!list_empty(&vs->vhost_scsi_list_entry))
+		return 0;
+
+	list_for_each_entry(md, &vhost_scsi_md_list, vhost_scsi_md_list_entry) {
+		lead_vs = list_first_entry(&md->vhost_scsi_list,
+					   struct vhost_scsi,
+					   vhost_scsi_list_entry);
+		if (memcmp(lead_vs->vs_vhost_wwpn, tgt->vhost_wwpn,
+			   sizeof(tgt->vhost_wwpn)))
+			continue;
+
+		goto add_vs;
+	}
+
+	md = kzalloc(sizeof(*md), GFP_KERNEL);
+	if (md)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&md->vhost_scsi_list);
+	INIT_LIST_HEAD(&md->vhost_scsi_md_list_entry);
+
+	list_add_tail(&md->vhost_scsi_md_list_entry, &vhost_scsi_md_list);
+
+add_vs:
+	switch (md->vs_cnt) {
+	case VHOST_SCSI_VQ_CTL:
+		vhost_vq_reset_kick_handler(&vs->vqs[0].vq,
+					    vhost_scsi_ctl_handle_kick);
+		break;
+	case VHOST_SCSI_VQ_EVT:
+		vhost_vq_reset_kick_handler(&vs->vqs[0].vq,
+					    vhost_scsi_evt_handle_kick);
+		break;
+	default:
+		vhost_vq_reset_kick_handler(&vs->vqs[0].vq,
+					    vhost_scsi_handle_kick);
+		break;
+	}
+
+	vs->md = md;
+	md->vs_cnt++;
+	list_add_tail(&vs->vhost_scsi_list_entry, &md->vhost_scsi_list);
+	return 0;
+}
+
 /*
  * Called from vhost_scsi_ioctl() context to walk the list of available
  * vhost_scsi_tpg with an active struct vhost_scsi_nexus
  *
  *  The lock nesting rule is:
- *    vhost_scsi_mutex -> vs->dev.mutex -> tpg->tv_tpg_mutex -> vq->mutex
+ *    vhost_scsi_tpg_mutex -> vs->dev.mutex -> tpg->tv_tpg_mutex -> vq->mutex
  */
 static int
 vhost_scsi_set_endpoint(struct vhost_scsi *vs,
@@ -1564,7 +1661,7 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 	int index, ret, i, len;
 	bool match = false;
 
-	mutex_lock(&vhost_scsi_mutex);
+	mutex_lock(&vhost_scsi_tpg_mutex);
 	mutex_lock(&vs->dev.mutex);
 
 	/* Verify that ring has been setup correctly. */
@@ -1585,13 +1682,14 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 	if (vs->vs_tpg)
 		memcpy(vs_tpg, vs->vs_tpg, len);
 
-	list_for_each_entry(tpg, &vhost_scsi_list, tv_tpg_list) {
+	list_for_each_entry(tpg, &vhost_scsi_tpg_list, tv_tpg_list) {
 		mutex_lock(&tpg->tv_tpg_mutex);
 		if (!tpg->tpg_nexus) {
 			mutex_unlock(&tpg->tv_tpg_mutex);
 			continue;
 		}
-		if (tpg->tv_tpg_vhost_count != 0) {
+		if (!vhost_scsi_multi_dev_per_nexus &&
+		    tpg->tv_tpg_vhost_count != 0) {
 			mutex_unlock(&tpg->tv_tpg_mutex);
 			continue;
 		}
@@ -1616,8 +1714,19 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 				mutex_unlock(&tpg->tv_tpg_mutex);
 				goto undepend;
 			}
+
+			ret = vhost_scsi_md_add_vs(vs, t);
+			if (ret)
+				goto undepend;
+
+			/*
+			 * In md mode the first vs added will be used for the
+			 * event queue. In non-md mode we only have the 1 vs.
+			 */
+			if (!tpg->vhost_scsi)
+				tpg->vhost_scsi = vs;
+
 			tpg->tv_tpg_vhost_count++;
-			tpg->vhost_scsi = vs;
 			vs_tpg[tpg->tport_tpgt] = tpg;
 			match = true;
 		}
@@ -1628,7 +1737,7 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 		memcpy(vs->vs_vhost_wwpn, t->vhost_wwpn,
 		       sizeof(vs->vs_vhost_wwpn));
 
-		for (i = VHOST_SCSI_VQ_IO; i < VHOST_SCSI_MAX_VQ; i++) {
+		for (i = VHOST_SCSI_VQ_IO; i < vs->dev.nvqs; i++) {
 			vq = &vs->vqs[i].vq;
 			if (!vq->initialized)
 				continue;
@@ -1637,7 +1746,7 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 				goto destroy_vq_cmds;
 		}
 
-		for (i = 0; i < VHOST_SCSI_MAX_VQ; i++) {
+		for (i = 0; i < vs->dev.nvqs; i++) {
 			vq = &vs->vqs[i].vq;
 			if (!vq->initialized)
 				continue;
@@ -1670,6 +1779,7 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 	for (i = 0; i < VHOST_SCSI_MAX_TARGET; i++) {
 		tpg = vs_tpg[i];
 		if (tpg) {
+			vhost_scsi_md_del_vs(vs);
 			tpg->tv_tpg_vhost_count--;
 			target_undepend_item(&tpg->se_tpg.tpg_group.cg_item);
 		}
@@ -1677,7 +1787,7 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 	kfree(vs_tpg);
 out:
 	mutex_unlock(&vs->dev.mutex);
-	mutex_unlock(&vhost_scsi_mutex);
+	mutex_unlock(&vhost_scsi_tpg_mutex);
 	return ret;
 }
 
@@ -1693,7 +1803,7 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 	int index, ret, i;
 	u8 target;
 
-	mutex_lock(&vhost_scsi_mutex);
+	mutex_lock(&vhost_scsi_tpg_mutex);
 	mutex_lock(&vs->dev.mutex);
 	/* Verify that ring has been setup correctly. */
 	for (index = 0; index < vs->dev.max_nvqs; ++index) {
@@ -1732,6 +1842,7 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 		tpg->tv_tpg_vhost_count--;
 		tpg->vhost_scsi = NULL;
 		vs->vs_tpg[target] = NULL;
+		vhost_scsi_md_del_vs(vs);
 		match = true;
 		mutex_unlock(&tpg->tv_tpg_mutex);
 		/*
@@ -1742,7 +1853,7 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 		target_undepend_item(&se_tpg->tpg_group.cg_item);
 	}
 	if (match) {
-		for (i = 0; i < VHOST_SCSI_MAX_VQ; i++) {
+		for (i = 0; i < vs->dev.nvqs; i++) {
 			vq = &vs->vqs[i].vq;
 			if (!vq->initialized)
 				continue;
@@ -1767,14 +1878,14 @@ static int vhost_scsi_setup_vq_cmds(struct vhost_virtqueue *vq, int max_cmds)
 	vs->vs_tpg = NULL;
 	WARN_ON(vs->vs_events_nr);
 	mutex_unlock(&vs->dev.mutex);
-	mutex_unlock(&vhost_scsi_mutex);
+	mutex_unlock(&vhost_scsi_tpg_mutex);
 	return 0;
 
 err_tpg:
 	mutex_unlock(&tpg->tv_tpg_mutex);
 err_dev:
 	mutex_unlock(&vs->dev.mutex);
-	mutex_unlock(&vhost_scsi_mutex);
+	mutex_unlock(&vhost_scsi_tpg_mutex);
 	return ret;
 }
 
@@ -1793,7 +1904,7 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
 		return -EFAULT;
 	}
 
-	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++) {
+	for (i = 0; i < vs->dev.nvqs; i++) {
 		vq = &vs->vqs[i].vq;
 		mutex_lock(&vq->mutex);
 		vq->acked_features = features;
@@ -1803,11 +1914,48 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
 	return 0;
 }
 
+static struct vhost_virtqueue **
+vhost_scsi_vqs_init(struct vhost_scsi *vs, int max_nvqs)
+{
+	struct vhost_virtqueue **vqs;
+	int i;
+
+	vs->vqs = kcalloc(max_nvqs, sizeof(*vs->vqs), GFP_KERNEL);
+	if (!vs->vqs)
+		return NULL;
+
+	vqs = kcalloc(max_nvqs, sizeof(*vqs), GFP_KERNEL);
+	if (!vqs)
+		goto err_vqs;
+
+	if (!vs->md_enabled) {
+		vqs[VHOST_SCSI_VQ_CTL] = &vs->vqs[VHOST_SCSI_VQ_CTL].vq;
+		vqs[VHOST_SCSI_VQ_EVT] = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
+		vs->vqs[VHOST_SCSI_VQ_CTL].vq.handle_kick =
+						vhost_scsi_ctl_handle_kick;
+		vs->vqs[VHOST_SCSI_VQ_EVT].vq.handle_kick =
+						vhost_scsi_evt_handle_kick;
+		for (i = VHOST_SCSI_VQ_IO; i < max_nvqs; i++) {
+			vqs[i] = &vs->vqs[i].vq;
+			vs->vqs[i].vq.handle_kick = vhost_scsi_handle_kick;
+		}
+	} else {
+		vqs[0] = &vs->vqs[0].vq;
+		vs->vqs[0].vq.handle_kick = vhost_scsi_no_op_kick;
+	}
+
+	return vqs;
+
+err_vqs:
+	kfree(vs->vqs);
+	return NULL;
+}
+
 static int vhost_scsi_open(struct inode *inode, struct file *f)
 {
 	struct vhost_scsi *vs;
 	struct vhost_virtqueue **vqs;
-	int r = -ENOMEM, i;
+	int r = -ENOMEM, nvqs, max_nvqs;
 
 	vs = kzalloc(sizeof(*vs), GFP_KERNEL | __GFP_NOWARN | __GFP_RETRY_MAYFAIL);
 	if (!vs) {
@@ -1815,10 +1963,20 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 		if (!vs)
 			goto err_vs;
 	}
+	INIT_LIST_HEAD(&vs->vhost_scsi_list_entry);
+	vs->md_enabled = vhost_scsi_multi_dev_per_nexus;
 
-	vqs = kmalloc_array(VHOST_SCSI_MAX_VQ, sizeof(*vqs), GFP_KERNEL);
-	if (!vqs)
-		goto err_vqs;
+	if (vs->md_enabled) {
+		max_nvqs = 1;
+		nvqs = 1;
+	} else {
+		/*
+		 * We will always need the ctl, evt and at least 1 IO vq.
+		 * Create more IO vqs if userspace requests them.
+		 */
+		max_nvqs = VHOST_SCSI_MAX_VQ;
+		nvqs = 3;
+	}
 
 	vhost_work_init(&vs->vs_completion_work, vhost_scsi_complete_cmd_work);
 	vhost_work_init(&vs->vs_event_work, vhost_scsi_evt_work);
@@ -1826,20 +1984,11 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 	vs->vs_events_nr = 0;
 	vs->vs_events_missed = false;
 
-	vqs[VHOST_SCSI_VQ_CTL] = &vs->vqs[VHOST_SCSI_VQ_CTL].vq;
-	vqs[VHOST_SCSI_VQ_EVT] = &vs->vqs[VHOST_SCSI_VQ_EVT].vq;
-	vs->vqs[VHOST_SCSI_VQ_CTL].vq.handle_kick = vhost_scsi_ctl_handle_kick;
-	vs->vqs[VHOST_SCSI_VQ_EVT].vq.handle_kick = vhost_scsi_evt_handle_kick;
-	for (i = VHOST_SCSI_VQ_IO; i < VHOST_SCSI_MAX_VQ; i++) {
-		vqs[i] = &vs->vqs[i].vq;
-		vs->vqs[i].vq.handle_kick = vhost_scsi_handle_kick;
-	}
+	vqs = vhost_scsi_vqs_init(vs, max_nvqs);
+	if (!vqs)
+		goto err_vqs_init;
 
-	/*
-	 * We will always need the ctl, evt and at least 1 IO vq. Create more
-	 * IO vqs if userspace requests them.
-	 */
-	r = vhost_dev_init(&vs->dev, vqs, 3, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
+	r = vhost_dev_init(&vs->dev, vqs, nvqs, max_nvqs, UIO_MAXIOV,
 			   VHOST_SCSI_WEIGHT, 0, true, NULL);
 	if (r)
 		goto err_dev_init;
@@ -1851,7 +2000,8 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 
 err_dev_init:
 	kfree(vqs);
-err_vqs:
+	kfree(vs->vqs);
+err_vqs_init:
 	kvfree(vs);
 err_vs:
 	return r;
@@ -1871,6 +2021,7 @@ static int vhost_scsi_release(struct inode *inode, struct file *f)
 	/* Jobs can re-queue themselves in evt kick handler. Do extra flush. */
 	vhost_scsi_flush(vs);
 	kfree(vs->dev.vqs);
+	kfree(vs->vqs);
 	kvfree(vs);
 	return 0;
 }
@@ -2035,7 +2186,7 @@ static int vhost_scsi_port_link(struct se_portal_group *se_tpg,
 	INIT_LIST_HEAD(&tmf->queue_entry);
 	vhost_work_init(&tmf->vwork, vhost_scsi_tmf_resp_work);
 
-	mutex_lock(&vhost_scsi_mutex);
+	mutex_lock(&vhost_scsi_tpg_mutex);
 
 	mutex_lock(&tpg->tv_tpg_mutex);
 	tpg->tv_tpg_port_count++;
@@ -2044,7 +2195,7 @@ static int vhost_scsi_port_link(struct se_portal_group *se_tpg,
 
 	vhost_scsi_hotplug(tpg, lun);
 
-	mutex_unlock(&vhost_scsi_mutex);
+	mutex_unlock(&vhost_scsi_tpg_mutex);
 
 	return 0;
 }
@@ -2056,7 +2207,7 @@ static void vhost_scsi_port_unlink(struct se_portal_group *se_tpg,
 				struct vhost_scsi_tpg, se_tpg);
 	struct vhost_scsi_tmf *tmf;
 
-	mutex_lock(&vhost_scsi_mutex);
+	mutex_lock(&vhost_scsi_tpg_mutex);
 
 	mutex_lock(&tpg->tv_tpg_mutex);
 	tpg->tv_tpg_port_count--;
@@ -2068,7 +2219,7 @@ static void vhost_scsi_port_unlink(struct se_portal_group *se_tpg,
 
 	vhost_scsi_hotunplug(tpg, lun);
 
-	mutex_unlock(&vhost_scsi_mutex);
+	mutex_unlock(&vhost_scsi_tpg_mutex);
 }
 
 static ssize_t vhost_scsi_tpg_attrib_fabric_prot_type_store(
@@ -2333,9 +2484,9 @@ static ssize_t vhost_scsi_tpg_nexus_store(struct config_item *item,
 		kfree(tpg);
 		return NULL;
 	}
-	mutex_lock(&vhost_scsi_mutex);
-	list_add_tail(&tpg->tv_tpg_list, &vhost_scsi_list);
-	mutex_unlock(&vhost_scsi_mutex);
+	mutex_lock(&vhost_scsi_tpg_mutex);
+	list_add_tail(&tpg->tv_tpg_list, &vhost_scsi_tpg_list);
+	mutex_unlock(&vhost_scsi_tpg_mutex);
 
 	return &tpg->se_tpg;
 }
@@ -2345,9 +2496,9 @@ static void vhost_scsi_drop_tpg(struct se_portal_group *se_tpg)
 	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
 				struct vhost_scsi_tpg, se_tpg);
 
-	mutex_lock(&vhost_scsi_mutex);
+	mutex_lock(&vhost_scsi_tpg_mutex);
 	list_del(&tpg->tv_tpg_list);
-	mutex_unlock(&vhost_scsi_mutex);
+	mutex_unlock(&vhost_scsi_tpg_mutex);
 	/*
 	 * Release the virtual I_T Nexus for this vhost TPG
 	 */
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 2ca2e71..d44351c 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -199,6 +199,25 @@ void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
 }
 EXPORT_SYMBOL_GPL(vhost_poll_init);
 
+static void vhost_poll_reinit_work(struct vhost_poll *poll, vhost_work_fn_t fn)
+{
+	vhost_work_init(&poll->work, fn);
+}
+
+/**
+ * vhost_vq_reset_kick_handler: reset the vq's kick handler
+ * @vq: vq to reset
+ * @fn: new kick function
+ *
+ * This must be called before the vq is activated
+ */
+void vhost_vq_reset_kick_handler(struct vhost_virtqueue *vq, vhost_work_fn_t fn)
+{
+	vq->handle_kick = fn;
+	vhost_poll_reinit_work(&vq->poll, fn);
+}
+EXPORT_SYMBOL_GPL(vhost_vq_reset_kick_handler);
+
 /* Start polling a file. We add ourselves to file's wait queue. The caller must
  * keep a reference to a file until after vhost_poll_stop is called. */
 int vhost_poll_start(struct vhost_poll *poll, struct file *file)
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 08c5aef..d748cb7 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -193,6 +193,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct vhost_log *log, unsigned int *log_num);
 void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 
+void vhost_vq_reset_kick_handler(struct vhost_virtqueue *vq, vhost_work_fn_t fn);
 int vhost_vq_init_access(struct vhost_virtqueue *);
 int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
 int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,


