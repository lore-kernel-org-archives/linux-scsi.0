From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Fri, 6 Mar 2015 14:36:19 +0100
Message-ID: <54F9AD53.60606@sandisk.com>
References: <54B63F74.2040702@sandisk.com>
 <20150115090829.GA14154@infradead.org> <54B7E70C.8020304@sandisk.com>
 <20150119092153.GA8666@infradead.org> <54BCD00D.4080603@sandisk.com>
 <54E7112F.2080901@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0085.outbound.protection.outlook.com ([157.56.111.85]:19282
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751086AbbCFNg2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Mar 2015 08:36:28 -0500
In-Reply-To: <54E7112F.2080901@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Dr. Greg Wettstein" <greg@wind.enjellic.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/20/15 11:49, Bart Van Assche wrote:
> On 01/19/15 10:36, Bart Van Assche wrote:
>> On 01/19/15 10:22, Christoph Hellwig wrote:
>>> On Thu, Jan 15, 2015 at 05:13:00PM +0100, Bart Van Assche wrote:
>>>> My goal is to realize this proposal without adding hooks for out-of-tree
>>>> code in the upstream kernel. What I had in mind is to raise the
>>>> abstraction level of the API between LIO core and target drivers a
>>>> little bit (e.g. by using accessor functions where necessary instead of
>>>> accessing structure members directly)
>>>
>>> That's very much a hook, althiugh a week one.
>>>
>>> Either way I don't think bringing up a very much political topic
>>> without even any code to discuss isn't a very valueable use of our time
>>> slots.
>>
>> A possible approach is that I start implementing a unified SRP target
>> driver and post that driver together with the necessary LIO and SCST
>> core changes before the LSF/MM starts. That could be a helpful starting
>> point for further discussions.
> 
> (replying to my own e-mail)
> 
> Hello Christoph,
> 
> What I proposed myself consists of three steps:
> 1. Updating the LIO SRP target driver to a more recent version.
> 2. Target driver and LIO core refactoring such that the LIO and
>    SCST APIs can be unified.
> 3. Adding support in SCST for the unified target driver API.
> 
> This work is taking a little more time than I had expected - I still
> have to start with step (3). But I can already show in which direction I
> would like to go for steps (1) and (2). The 43 patches I came up with so
> far for steps (1) and (2) are available in the lio branch of the
> https://github.com/bvanassche/linux git repository. As you can see in
> that repository 42 of these 43 patches make sense even without knowing
> that something like SCST exists.

(again replying to my own e-mail)

Hello everyone,

As promised a prototype of the implementation of the unified target
drive API for SCST has been made available publicly (see also
https://github.com/bvanassche/scst-prototype-for-lsf-mm/tree/unified-target-driver-api).
Although this is still a prototype I think this code illustrates that it
is possible to unify the target driver APIs.

The patches in the unified-target-driver-api branch on top of the
SourceForge SCST trunk are:
0001-Add-.gitignore.patch
0002-scst-Introduce-task_mgmt_fn_pre_exec-in-the-target-t.patch
0003-scst-Add-unified-target-driver-API.patch
0004-srpt-unified-Import-source-files-from-lio-kernel-bra.patch
0005-srpt-unified-Add-out-of-tree-build-infrastructure.patch
0006-srpt-unified-Make-this-driver-build-against-the-unif.patch

Patches 2 and 3 add an implementation of the unified target driver API
in SCST. Header files are added under scst/include with the same names
as the LIO header files. The implementation of that API translates e.g.
between ranges of enumeration constants and also between the target
driver registration templates of the two projects.

Patch 4 imports the SRP target driver source code from the git
repository mentioned in my previous e-mail.

Patch 5 adds a makefile that allows to build that driver as an
out-of-tree kernel driver. The compiler include path is set up such that
the compiler finds the unified header files under scst/include first.

Patch 6 makes the unified SRP target driver build against the SCST
version of the unified API. The following conclusions can be drawn from
that patch:
- A few user space ABI differences are addressed via #ifdefs (GUID
  format "%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x" for SCST versus
  "0x%04x%04x%04x%04x%04x%04x%04x%04x" for LIO and target driver entry
  point ib_srpt for SCST versus srpt for LIO).
- That patch contains further unification of the target driver API, e.g.
  introduction of functions like transport_get_data_out_buf(),
  target_cmd_done(), transport_get_resid(), transport_sense_valid() etc.
- Since the SCST core manages a list of SCSI target ports, the
  port_list data structure isn't needed in the SCST version of this
  target driver.
- In some areas further unification is needed, e.g. the enable_target()
  / is_target_enabled() callback functions and also for the API for
  session unregistration (see also the transport_deregister_session()
  call). As one can see the persistent reservation TransportID callback
  functions have not yet been unified. However, I think these should be
  unified and also that this is possible without too much effort.
- Another open issue is that creation of target driver configfs/sysfs
  attributes is not yet supported in this prototype of the SCST version
  of the unified target driver API.

Bart.
