From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: target: problems with Persistent reservations, iscsi
Date: Thu, 06 Jan 2011 14:06:23 -0800
Message-ID: <1294351583.2895.87.camel@haakon2.linux-iscsi.org>
References: <a17263ef-dd96-468e-ad85-0f987cdacb4f@j25g2000yqa.googlegroups.com>
	 <1294184625.29002.29.camel@haakon2.linux-iscsi.org>
	 <20110105162720.GA4494@omega17.zumbi.com.ar>
	 <1294272793.14650.172.camel@haakon2.linux-iscsi.org>
	 <AANLkTik-A3sGw6t8b8pj9Q0vMoycTTiZiine-DK=pahZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34828 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab1AFWMX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2011 17:12:23 -0500
In-Reply-To: <AANLkTik-A3sGw6t8b8pj9Q0vMoycTTiZiine-DK=pahZ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gustavo Panizzo <gfaraway@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>

On Thu, 2011-01-06 at 18:22 -0300, Gustavo Panizzo wrote:
> On Wed, Jan 5, 2011 at 9:13 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > For proper production PR usage you really, *really* want to use explict NodeACLs with the
> > correct Initiator IQN names and disable demo mode all together.  However, it is possible to use
> > demo-mode with PR ops for non production (eg: testing) purposes, but it is not as nearly well
> > tested as using Explict Node ACLs.
> ok, i followed the guide. i'm not super familiar with iscsi
> after the tests you asked, i modified my setup to use *correct*
> nodenames on the acl and disabled the demo mode
> 

Hi Gustavo,

Thanks again for your follow up and helping to elimate TPG demo_mode
operation as the culprit.   My comments are below.

> >
> > So that said, there are two more tests I would like you to run to help isolate this particular
> > issue wrt to PR operation with demo mode (eg: generate_node_acls=1)
> >
> > *) Please go ahead and enable 'cache_dynamic_acls' for the TargetName+TargetPortalGroupTag endpoint
> > with the following and retest using the Vertias test suite.
> >
> > echo 1 > /sys/kernel/config/target/iscsi/iqn.2010.ar.com.zumbi:disk0/tpgt_1/attrib/cache_dynamic_acls
> it failed :(
> dmesg.test1 is the log file
> >
> > This will keep around the dynamically generated struct se_node_acls
> > which does have an effect on certain PR operations, but thus far you are
> > the first to the NULL pointer deference issue with demo mode PR
> > operation.
> >
> > *) From there, go ahead and disable demo mode all together for the TargetName+TargetPortalGroupTag
> > endpoint with:
> >
> > echo 0 > /sys/kernel/config/target/iscsi/iqn.2010.ar.com.zumbi:disk0/tpgt_1/attrib/generate_node_acls
> >
> > and fix the NodeACLs to match the actual initiator side IQNs and retest again.
> it failed too
> dmesg.test2 is the log file
> >

Ok, it appears that this OOPs is actually breakage for UNIT_ATTENTION
conditions from the addition of > 16 byte extended CDB support added
during the v4.0 development cycle last fall.  I am currently testing
with the patch below to ensure the T_TASK(cmd)->t_task_cdb pointer is
setup before the UA check in transport_generic_cmd_sequencer() can
return an exception, and will be verifying the fix shortly.

Please re-test your .37-rc7 setup with the following patch with explict
NodeACLs and/or TPG demo mode operation w/ cache_dynamic_acls=1 and let
us know your results.

Thanks!

--nab

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2b59890..02e92a3 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1897,13 +1897,6 @@ int transport_generic_allocate_tasks(
 
        transport_device_setup_cmd(cmd);
        /*
-        * See if this is a CDB which follows SAM, also grab a function
-        * pointer to see if we need to do extra work.
-        */
-       ret = transport_generic_cmd_sequencer(cmd, cdb);
-       if (ret < 0)
-               return ret;
-       /*
         * Ensure that the received CDB is less than the max (252 + 8) bytes
         * for VARIABLE_LENGTH_CMD
         */
@@ -1935,6 +1928,14 @@ int transport_generic_allocate_tasks(
         */
        memcpy(T_TASK(cmd)->t_task_cdb, cdb, scsi_command_size(cdb));
        /*
+        * Setup the received CDB based on SCSI defined opcodes and
+        * perform unit attention, persistent reservations and ALUA
+        * checks for virtual device backends.
+        */
+       ret = transport_generic_cmd_sequencer(cmd, cdb);
+       if (ret < 0)
+               return ret;
+       /*
         * Check for SAM Task Attribute Emulation
         */
        if (transport_check_alloc_task_attr(cmd) < 0) {


