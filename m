From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 21 Mar 2011 15:29:35 -0700
Message-ID: <1300746575.21880.76.camel@haakon2.linux-iscsi.org>
References: <20110307134033K.fujita.tomonori@lab.ntt.co.jp>
	 <1299508803.12730.1.camel@mulgrave.site>
	 <4D83C78D.5040908@linux.vnet.ibm.com>
	 <20110321100909E.fujita.tomonori@lab.ntt.co.jp>
	 <4D87BC8C.5090104@linux.vnet.ibm.com>
	 <1300741291.21880.17.camel@haakon2.linux-iscsi.org>
	 <4D87C22A.6070301@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60279 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab1CUWgq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2011 18:36:46 -0400
In-Reply-To: <4D87C22A.6070301@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On Mon, 2011-03-21 at 16:24 -0500, Brian King wrote:
> On 03/21/2011 04:01 PM, Nicholas A. Bellinger wrote:
> > On Mon, 2011-03-21 at 16:01 -0500, Brian King wrote:
> >> On 03/20/2011 08:09 PM, FUJITA Tomonori wrote:
> >>> Thanks for the testings,
> >>>
> >>> On Fri, 18 Mar 2011 15:58:53 -0500
> >>> Brian King <brking@linux.vnet.ibm.com> wrote:
> >>>
> >>>> On 03/07/2011 08:40 AM, James Bottomley wrote:
> >>>>> On Mon, 2011-03-07 at 13:41 +0900, FUJITA Tomonori wrote:
> >>>>>> On Sat, 12 Feb 2011 14:27:26 -0600
> >>>>>> James Bottomley <James.Bottomley@suse.de> wrote:
> >>>>>>
> >>>>>>>> Disregard my previous comment. It looks like current client should handle reservations
> >>>>>>>> just fine without any further changes.
> >>>>>>>
> >>>>>>> So is that an ack for putting this in scsi-misc ... or did you want to
> >>>>>>> do more testing first?
> >>>>>>
> >>>>>> Ping,
> >>>>>>
> >>>>>> Brian, James, can we merge this during the next merge window?
> >>>>>
> >>>>> I'm still waiting for an ack from Brian.
> >>>>
> >>>> Sorry for the delay... I've got this loaded in the lab and have managed to oops
> >>>> a couple times. The first one was during shutdown, which I wasn't able to collect
> >>>> any data for. The most recent occurred when a client was trying to login for the
> >>>> first time:
> >>>
> >>> You mean that the kernel crashes every time when a client logs in?
> >>
> >> I think the crash I was seeing when the client logs in was just due to the fact that
> >> I had things misconfigured. It took me a bit to figure out the configfs stuff. Didn't
> >> realize at first I had to go off and manually create a lot of the configfs layout
> >> described in the wiki page. Once I did that, I was able to get a LUN to successfully
> >> report in on the client side. I'll start pounding on this a bit and see how things
> >> hold up.
> >>
> > 
> > Hi Brian,
> > 
> > If could send along the original misconfigured configfs layout that is
> > causing the OOPs in handle_crq(), I would be happy to have a quick look.
> 
> Here it is. As you can see, there is no ./target/ibmvscsis directory created. In order
> to get it to work, I did the following. Please let me know if there is a better way
> to do this...
> 
> cd /sys/kernel/configfs/target
> mkdir -p ibmvscsis/30000003/tpgt_1
> mkdir ibmvscsis/30000003/tpgt_1/lun/lun_0
> ln -s core/fileio_0/testfvd ibmvscsis/30000003/tpgt_1/lun/lun_0/default
> 

This is correct..

> I had previously created a file backed lun via:
> 
> tcm_node --fileio fileio_0/testfvd /vdisks/test 100000000
> 
> Thanks,
> 
> Brian
> 
> 

So indeed, the issue appears to be that handle_crq() is running w/o a
configured /sys/kernel/config/target/ibmvscsis/$VSCSI_WWN/tpgt_1/
endpoint, but still receiving incoming I/O via handle_crq() ->
handle_cmd_queue() -> tcm_queuecommand()..

Which means that tcm_queuecommand() and struct ibmvscsis_adapter need to
be aware of some form of state between I/O and control path in order to
prevent adapter->se_tpg and adapter->se_sess from being referenced
before the TPG endpoint and VIO I_T Nexus (TCM Session) has been setup
with the explict mkdir(2) operation via target_core_fabric_configfs.c:
target_fabric_make_tpg() -> ibmvscsis_make_tpg() code.

I recall it being mentioned at some point that certain VIO clients had
issue with the failure of the (initial..?) expected INQUIRY, for which
is handled internally in ibmvscsis_queuecommand() code..

So that said, I think we have a couple of options here..

*) Add a lock to protect adapter->se_sess for I/O and
ibmvscsis_make_tpg() control path code, and find a way to gracefully
handle tcm_queuecommand() exceptions for non-configured targets
endpoints after the internally emulated INQUIRY is completed.

*) Determine if breaking up individual external VIO setup logic makes
more sense from being done in a global manner for all available VIO
target connections via:

    module_init() ->
	ibmvscsis_init() ->
		vio_register_probe() -> 

into a more flexable method via individually configured
target_core_fabric_configfs.c:target_fabric_make_tpg()
-> ibmvscsis_make_tpg(), where we don't actually pull the current
ibmvscsis_probe() -> crq_queue_create() until mkdir -p
$VIO_TARGET_FULLPATH/tpgt_1 has been preformed.

Obviously for the long term direction of this code I would prefer the
the latter and a more flexiable direction (Tomo-san, thoughts on
this..?).

To prevent this from happening with existing code, I think the following
should address the current OOPs.  Please have a look and let me know.

Thanks!

--nab

diff --git a/drivers/scsi/ibmvscsi/ibmvscsis.c b/drivers/scsi/ibmvscsi/ibmvscsis.c
index 714af48..a0cd9b8 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsis.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsis.c
@@ -98,6 +98,9 @@ struct ibmvscsis_adapter {
 
        struct work_struct crq_work;
 
+       /* lock for protecting ->se_sess */
+       spinlock_t sess_lock;
+
        unsigned long liobn;
        unsigned long riobn;
 
@@ -335,6 +338,7 @@ static struct se_portal_group *ibmvscsis_make_tpg(struct se_wwn *wwn,
        struct ibmvscsis_adapter *adapter =
                container_of(wwn, struct ibmvscsis_adapter, tport_wwn);
        struct se_node_acl *acl;
+       struct se_session *se_sess;
        int ret;
        char *dname = (char *)dev_name(&adapter->dma_dev->dev);
 
@@ -347,16 +351,15 @@ static struct se_portal_group *ibmvscsis_make_tpg(struct se_wwn *wwn,
        if (ret)
                return ERR_PTR(-ENOMEM);
 
-       adapter->se_sess = transport_init_session();
-       if (!adapter->se_sess) {
+       se_sess = transport_init_session();
+       if (!se_sess) {
                core_tpg_deregister(&adapter->se_tpg);
                return ERR_PTR(-ENOMEM);
        }
 
        acl = core_tpg_check_initiator_node_acl(&adapter->se_tpg, dname);
        if (!acl) {
-               transport_free_session(adapter->se_sess);
-               adapter->se_sess = NULL;
+               transport_free_session(se_sess);
                return ERR_PTR(-ENOMEM);
        }
        adapter->se_sess->se_node_acl = acl;
@@ -365,6 +368,10 @@ static struct se_portal_group *ibmvscsis_make_tpg(struct se_wwn *wwn,
                                   adapter->se_sess->se_node_acl,
                                   adapter->se_sess, adapter);
 
+       spin_lock_bh(&adapter->sess_lock);
+       adapter->se_sess = se_sess;
+       spin_unlock_bh(&adapter->sess_lock);
+
        return &adapter->se_tpg;
 }
@@ -372,16 +379,19 @@ static void ibmvscsis_drop_tpg(struct se_portal_group *se_tpg)
 {
        struct ibmvscsis_adapter *adapter =
                container_of(se_tpg, struct ibmvscsis_adapter, se_tpg);
+       struct se_session *se_sess;
        unsigned long flags;
+       
+       transport_deregister_session_configfs(adapter->se_sess);
 
+       spin_lock_bh(&adapter->sess_lock);
+       se_sess = adapter->se_sess;
+       adapter->se_sess = NULL;
+       spin_unlock_bh(&adapter->sess_lock);
 
-       transport_deregister_session_configfs(adapter->se_sess);
        transport_free_session(adapter->se_sess);
-       core_tpg_deregister(se_tpg);
 
-       spin_lock_irqsave(&tpg_lock, flags);
-       adapter->se_sess = NULL;
-       spin_unlock_irqrestore(&tpg_lock, flags);
+       core_tpg_deregister(se_tpg);
 }
 
 static struct se_wwn *ibmvscsis_make_tport(struct target_fabric_configfs *tf,
@@ -873,6 +883,17 @@ static int tcm_queuecommand(struct ibmvscsis_adapter *adapter,
        data_len = srp_data_length(cmd, srp_cmd_direction(cmd));
 
        se_cmd = &vsc->se_cmd;
+       /*
+        * Ensure that an adapter>se_sess and TCM TPG endpoint have been
+        * configured via ibmvscsis_make_tpg().
+        */
+       spin_lock_bh(&adapter->sess_lock);
+       if (!adapter->se_sess) {
+               spin_unlock_bh(&adapter->sess_lock);
+               printk(KERN_ERR "struct ibmvscsis_adapter->se_sess has not been configured\n");
+               return -ENODEV:
+       }
+       spin_unlock_bh(&adapter->sess_lock);
 
        transport_init_se_cmd(se_cmd,
                              adapter->se_tpg.se_tpg_tfo,
@@ -1576,6 +1597,7 @@ static int ibmvscsis_probe(struct vio_dev *dev, const struct vio_device_id *id)
        if (!adapter)
                return -ENOMEM;
 
+       spin_lock_init(&adapter->sess_lock);
        adapter->dma_dev = dev;
 
        dma = (unsigned int *)vio_get_attribute(dev, "ibm,my-dma-window",


