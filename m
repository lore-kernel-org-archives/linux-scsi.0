From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: ConfigFS + Target Mode Engine API discussion
Date: Wed, 10 Sep 2008 18:42:46 -0700
Message-ID: <1221097366.27831.216.camel@haakon2.linux-iscsi.org>
References: <1221087547.27831.165.camel@haakon2.linux-iscsi.org>
	 <20080910233107.GC23864@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:28823 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750818AbYIKBmt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2008 21:42:49 -0400
In-Reply-To: <20080910233107.GC23864@mail.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joel Becker <Joel.Becker@oracle.com>
Cc: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, SCST-Devel <scst-devel@lists.sourceforge.net>

On Wed, 2008-09-10 at 16:31 -0700, Joel Becker wrote:
> On Wed, Sep 10, 2008 at 03:59:07PM -0700, Nicholas A. Bellinger wrote:
> > Whoops, forgot to CC you boss. :-)
> 
> 	FYI, I'll be at both KSummit and Plumbers.
> 
> Joel
> 

Great, I look forward to catching up.. :-)

Btw, I started working on the target related configfs this past weekend,
and stuck on one particular item wrt the API of a target mode fabric
plugin with a configfs enabled target engine under
$CONFIGFS/target/$FABRIC

I am making a default group under $CONFIGFS/target/core that will be
used for the generic target engine for storage object registration and
device object tuning related to target mode export, etc.  From there, I
expect the target fabric modules that are being loaded to call the
following API routines at modprobe time from a previously allocated
struct configfs_subsystem:

extern struct config_group *target_fabric_configfs_init (void)
{
        struct configfs_subsystem *subsys;

        subsys = &target_core_subsystem[0];
        return(&subsys->su_group);
}

extern struct config_group *target_fabric_configfs_register (
        struct config_group *su_cg,
        char *name,
        struct config_item_type *fabric_cit)
{

	if (!(fabric_cg = kzalloc(struct config_group, GFP_NORMAL))) {
                printk(KERN_ERR "Unable to allocate fabric_cg\n");
                ERR_PTR(-ENOMEM);
        }

        config_group_init_type_name(fabric_cg, name, fabric_cit);

}

So I am thinking about the following question:  What would be the
preferred method for calling ct_group_ops->make_group() in order to
create the $CONFIGFS/target/$FABRIC struct config_item directly from
target_fabric_configfs_register() call?  From there, the config group
hanging off $CONFIGFS/target/$FABRIC will be fabric dependent and
providing their own groups, items, depends, from the passed *fabric_cit.
How do I "simulate" a mkdir(2) configfs -> make_group() call coming from
the fabric module itself..?   This would be assuming that both mkdir(2)
and rmdir(2) would be *NOT* be able to be called directly on
$CONFIGFS/target/$FABRIC, and only the rmmod $FABRIC_MOD will call
target_fabric_configfs_unregister() and -> drop_item() to remove the
$FABRIC plugin from $CONFIGFS/target/

The configfs enabled generic target engine will need similar
functionality to simulate mkdir(2) -> make_group() and rmdir(2) ->
drop_item() in order for autoregistration of storage objects using echo
$STORAGE_OBJECT > $CONFIGFS/target/$FABRIC/$FABRIC_ENDPOINT/lun_0 to
setup the mapping as I envision.

Thanks Joel!

--nab




