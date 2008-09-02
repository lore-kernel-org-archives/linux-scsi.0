From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Kernel Level Generic Target Mode control path
Date: Tue, 02 Sep 2008 14:25:29 -0700
Message-ID: <1220390729.13470.738.camel@haakon2.linux-iscsi.org>
References: <48ADC53B.6090501@vlnb.net>  <48ADFAB7.5010201@cs.wisc.edu>
	 <1219701570.13470.156.camel@haakon2.linux-iscsi.org>
	 <48B59556.7050108@vlnb.net>
	 <1219875219.13470.380.camel@haakon2.linux-iscsi.org>
	 <48B6E5C8.2000306@vlnb.net>
	 <1219964919.13470.505.camel@haakon2.linux-iscsi.org>
	 <48B823C4.7010803@vlnb.net>
	 <1220040606.13470.585.camel@haakon2.linux-iscsi.org>
	 <48B9B33C.2060106@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:22887 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751307AbYIBVcL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Sep 2008 17:32:11 -0400
In-Reply-To: <48B9B33C.2060106@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>, Greg KH <greg@kroah.com>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, Jerome Martin <tramjoe.merin@gmail.com>

On Sun, 2008-08-31 at 00:53 +0400, Vladislav Bolkhovitin wrote:
> Nicholas A. Bellinger wrote:
> > On Fri, 2008-08-29 at 20:28 +0400, Vladislav Bolkhovitin wrote:
> >> Nicholas A. Bellinger wrote:
> >
> > Vlad, they are atomic.  No iSCSI Initiator are allowed to login to the
> > TargetName+TPGT until:
> > 
> >> # This is the atomic part, once we throw this flag iSCSI Initiatorswill
> >>> be allowed to login to this TPGT
> >>> echo 1 > $MY_TARGETIQN/tpgt_1/enable_tpg
> > 
> > Each TargetName+TPGT is protected when a 'target-ctl' IOCTL op related
> > to TargetName+TPGT is called.  The same is true for configfs, any time
> > anything under $MY_TARGETIQN is accessed or created, we take the
> > iscsi_tiqn_t mutex to protect it.    When anything under
> > $MY_TARGETIQN/tpgt_# is accessed, the iscsi_portal_group_t mutex is
> > protecting it.
> > 
> > With until enable_tpg to let initiators login to that TargetName+TPGT, I
> > honestly do not see your concern here.
> > 
> >> and on the target driver's start 
> >> configuration of *all* targets as a whole should be atomic as well. How 
> >> are you going to solve this issue?
> >>
> > 
> > In what example would ALL iSCSI TargetName context configuration need to
> > be atomic to each other..?  Having the LIO-Target design above I have
> > never ran into a requirement like this, what requirement do you have in
> > mind..?  
> 
> I've already written it: when target restarted. Disconnected initiators 
> can reconnect on the wrong time and can see "no target", then consider 
> it dead.

Yes, this case you describe is exactly what I am talking about with the
"enable_tpg" flag for LIO-Target under configfs.  Each fabric can define
it's own configfs groups and items to fit its own requirements, which
means, that a global "allow initiators to login" flag would like look:

FABRIC=pscsi

# Allow all initiators to login to all Parallel SCSI endpoints
echo 1 > /sys/kernel/config/target/$FABRIC/allow_initiators_to_login

Or, just enable one endpoint on another fabric:

FABRIC=sas

# Only allow initiators to login to sas_endpoint_name 
echo 1 > /sys/kernel/config/target/$FABRIC/sas_endpoint_name/enable_login

Anyways, you get the idea.  The great part of course is that this
requires zero changes to userspace code!!

>  The same is true for target shutdown: it should be atomic too.
> 

I am not debating these fundementals, I am mearly saying that depending
upon configfs for target configuration would entail the same types of
logic and mutual exclusion requirements in procfs, sysfs, or an IOCTL.

> >> 2. The high level interface needs to lock somehow the low level 
> >> interface during updates to protect from simultaneous actions. I don't 
> >> see a simple way to do that in configfs.
> >>
> > 
> > Not having problem locking/mutex are in place is going to cause problems
> > regardless of configfs is used.  Converting LIO-Target from IOCTL ->
> > configfs is really easy because all of the target-ctl IOCTL ops are
> > already protected, so using things like a configfs trigger are simple
> > because I do not have to add any additional locking considerations
> > because the ops are already protected in the IOCTL context.
> 
> What would be if a program, who taken that mutex get dead before 
> releasing it? You wouldn't receive a notification about its death, 
> although with IOCTL's you would receive it. Will you invent a motex 
> revoking mechanism for that.
> 

Hrrmm, why would an IOCTL process context be any different than a
configfs process context..?  Just because a userspace process is running
kernel code and user hits CTRL-C, or the userspace code segfaults, does
not mean the kernel code stops running, it just means that those SIGINT
or SIGSEGVs are pending for that process and down_interruptible()
semaphores will not sleep and signal_pending(current) will return TRUE,
etc.

I still don't see how the case of a userspace process accessing kernel
code would be different between an IOCTL and configfs process context..?


> >>>> Sysfs as well as configfs have one big disadvantage. They limit each 
> >>>> file to only 4KB. This would force us for to create a subdirectory for 
> >>>> each device and for each connected initiator. I don't like seeing 
> >>>> thousands subdirectories. Additionally, such layout is a lot less 
> >>>> convenient for parsing for the high level configuration tool, which 
> >>>> needs to find out the difference between the current configuration and 
> >>>> content of the corresponding config file.
> >>>>
> >>> So yeah, the output with configfs is limited to PAGE_SIZE as well, but
> >>> for the R/W cases we don't expect that data sets to exceed this per
> >>> configfs mkdir invocation.. 
> >>>
> >>>> Currently, with procfs SCST can list in /proc/scst/sessions virtually 
> >>>> unlimited amount of connected initiators in a simple for parsing manner. 
> >>>> It was done using seq interface well and simply. Neither sysfs, nor 
> >>>> configfs support seq interface. This would introduce significant effort 
> >>>> in both kernel and user spaces.
> >>>>
> >>> Same for me with all of the target-ctl IOCTL commands.   No one ever
> >>> said upstream target code was not going to require significant
> >>> effort. :-)
> >> I don't think we should create the additional one :-)
> >>
> > 
> > We are not creating a new one, we are using one that already exists
> > upstream that was made for exactly the type of problem we are looking to
> > solve.  Using procfs or and IOCTL for anything serious upstream is not
> > an option, not because they upstream maintainers like to make our life
> > hard, but because they are poor interfaces for what we want to do.
> > 
> > Vlad, please consider configfs.  After evaluating my requirements with
> > LIO-Target, there is no technical hangups or major gotchas I can see for
> > implementing the above example.  I know that LIO-Target with the example
> > above there are *NO* "atomicity of changes" issues I have from simply
> > converting IOCTL -> configfs, because the LIO-Target code called from
> > IOCTL already does the protection for the different contexts provided
> > for the example, and $MY_TARGETIQN/tpgt_#/enable_tpg protects iSCSI
> > Initiators from logging into that endpoint to access storage object
> > LUNs.
> > 
> > How you give an problem case where you think a generic target engine
> > configuration scenario would not work with configfs, and I will explain
> > how with LIO-Target/LIO-Core it would and does work..?
> 
> I have the only thing against configfs: I feel that using it could be 
> harder than using well thought IOCTL interface. What's definite, that 
> amount of in-kernel code for configfs will be considerably bigger, than 
> for IOCTLs, but this is thing about what kernel developers do carefully 
> care. In my observations
> 

I think the kernel code would be a bit larger using configfs, but equal
logic and complexity with an IOCTL.  The great benefit with configfs of
course is that you never have to break compatibility from having to
change your struct foo that is passed with the IOCTL between
kernel/user.  Also, not having to maintain a mess of C userspace code is
always a benefit.  With configfs the target CLI that I have in mind
would basically be all shell scripts reference admin defined human
readable aliases mapped to targetname, target portals, storage objects,
LUNs, etc.

> But if you so excited about configfs and willing to take care about all 
> the headaches of moving to it, I won't object.
> 

:-)

> I only always thought that considering possible options means 
> considering them all, but I feel you didn't read what I wrote below 
> about IOCTL interface ;)
> 

Well, since I have been using an IOCTL for so long with LIO, I am
painfully fimilar with the benefits and limitations..

> I'm leaving now, so let's return to the discussion in two weeks time.
> 

Sounds good!

--nab


