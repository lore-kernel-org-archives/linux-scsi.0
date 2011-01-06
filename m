From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: target: problems with Persistent reservations, iscsi
Date: Thu, 06 Jan 2011 14:51:53 -0800
Message-ID: <1294354313.2895.93.camel@haakon2.linux-iscsi.org>
References: <a17263ef-dd96-468e-ad85-0f987cdacb4f@j25g2000yqa.googlegroups.com>
	 <1294184625.29002.29.camel@haakon2.linux-iscsi.org>
	 <20110105162720.GA4494@omega17.zumbi.com.ar>
	 <1294272793.14650.172.camel@haakon2.linux-iscsi.org>
	 <AANLkTik-A3sGw6t8b8pj9Q0vMoycTTiZiine-DK=pahZ@mail.gmail.com>
	 <1294351583.2895.87.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52128 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1AFW5w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2011 17:57:52 -0500
In-Reply-To: <1294351583.2895.87.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gustavo Panizzo <gfaraway@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>

On Thu, 2011-01-06 at 14:06 -0800, Nicholas A. Bellinger wrote:
> On Thu, 2011-01-06 at 18:22 -0300, Gustavo Panizzo wrote:
> > On Wed, Jan 5, 2011 at 9:13 PM, Nicholas A. Bellinger
> > <nab@linux-iscsi.org> wrote:

<SNIP>

> > >
> > > So that said, there are two more tests I would like you to run to help isolate this particular
> > > issue wrt to PR operation with demo mode (eg: generate_node_acls=1)
> > >
> > > *) Please go ahead and enable 'cache_dynamic_acls' for the TargetName+TargetPortalGroupTag endpoint
> > > with the following and retest using the Vertias test suite.
> > >
> > > echo 1 > /sys/kernel/config/target/iscsi/iqn.2010.ar.com.zumbi:disk0/tpgt_1/attrib/cache_dynamic_acls
> > it failed :(
> > dmesg.test1 is the log file
> > >
> > > This will keep around the dynamically generated struct se_node_acls
> > > which does have an effect on certain PR operations, but thus far you are
> > > the first to the NULL pointer deference issue with demo mode PR
> > > operation.
> > >
> > > *) From there, go ahead and disable demo mode all together for the TargetName+TargetPortalGroupTag
> > > endpoint with:
> > >
> > > echo 0 > /sys/kernel/config/target/iscsi/iqn.2010.ar.com.zumbi:disk0/tpgt_1/attrib/generate_node_acls
> > >
> > > and fix the NodeACLs to match the actual initiator side IQNs and retest again.
> > it failed too
> > dmesg.test2 is the log file
> > >
> 
> Ok, it appears that this OOPs is actually breakage for UNIT_ATTENTION
> conditions from the addition of > 16 byte extended CDB support added
> during the v4.0 development cycle last fall.  I am currently testing
> with the patch below to ensure the T_TASK(cmd)->t_task_cdb pointer is
> setup before the UA check in transport_generic_cmd_sequencer() can
> return an exception, and will be verifying the fix shortly.
> 
> Please re-test your .37-rc7 setup with the following patch with explict
> NodeACLs and/or TPG demo mode operation w/ cache_dynamic_acls=1 and let
> us know your results.
> 
> Thanks!
> 

Hi again Gustavo,

I have been able to reproduce the issue and verify the bugfix with the
patch below.  The following patch has now been pushed into lio-4.0 and
master (upgraded recently to .37-FINAL) and sent out seperately to
linux-scsi to be picked up for mainline.

target: Fix T_TASK(cmd)->t_task_cdb assignement breakage
http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=ff49f510a3a837ec6bd87eccac65bff31d5de561

Thanks for your bug report!

--nab

> --nab
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 2b59890..02e92a3 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1897,13 +1897,6 @@ int transport_generic_allocate_tasks(
>  
>         transport_device_setup_cmd(cmd);
>         /*
> -        * See if this is a CDB which follows SAM, also grab a function
> -        * pointer to see if we need to do extra work.
> -        */
> -       ret = transport_generic_cmd_sequencer(cmd, cdb);
> -       if (ret < 0)
> -               return ret;
> -       /*
>          * Ensure that the received CDB is less than the max (252 + 8) bytes
>          * for VARIABLE_LENGTH_CMD
>          */
> @@ -1935,6 +1928,14 @@ int transport_generic_allocate_tasks(
>          */
>         memcpy(T_TASK(cmd)->t_task_cdb, cdb, scsi_command_size(cdb));
>         /*
> +        * Setup the received CDB based on SCSI defined opcodes and
> +        * perform unit attention, persistent reservations and ALUA
> +        * checks for virtual device backends.
> +        */
> +       ret = transport_generic_cmd_sequencer(cmd, cdb);
> +       if (ret < 0)
> +               return ret;
> +       /*
>          * Check for SAM Task Attribute Emulation
>          */
>         if (transport_check_alloc_task_attr(cmd) < 0) {
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

