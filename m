Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8462C47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 14:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CCE260C40
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 14:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhFJObR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 10:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhFJObQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 10:31:16 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0A4C061574;
        Thu, 10 Jun 2021 07:29:20 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id D3857128050D;
        Thu, 10 Jun 2021 07:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1623335359;
        bh=2/0lPEeOpYIQJ4OTN2vggbH8CFxTFnKsCMcfeMBMLWI=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=aD4b7ZX5SDD5NgFpZbhgLldqaqj3hGsLrj9RgoxizGV67zrHE8K7g0XAxYOo8VbdU
         83dKyy9hUOEE+dDbiR2LL1Zt+j68RvynqUQh7GVt4aAhKkn50KEjiDG8M3wbTfhiMT
         pyDF0jAJ0Nm5t4+7BN5g4ikhX3e6zQrO/puCn01s=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fyVwcYQyOesn; Thu, 10 Jun 2021 07:29:19 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 75E681280501;
        Thu, 10 Jun 2021 07:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1623335359;
        bh=2/0lPEeOpYIQJ4OTN2vggbH8CFxTFnKsCMcfeMBMLWI=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=aD4b7ZX5SDD5NgFpZbhgLldqaqj3hGsLrj9RgoxizGV67zrHE8K7g0XAxYOo8VbdU
         83dKyy9hUOEE+dDbiR2LL1Zt+j68RvynqUQh7GVt4aAhKkn50KEjiDG8M3wbTfhiMT
         pyDF0jAJ0Nm5t4+7BN5g4ikhX3e6zQrO/puCn01s=
Message-ID: <f31fbb6d2f374a39d22e3fca122d757e905d2711.camel@HansenPartnership.com>
Subject: Re: [LSF/MM/BPF TOPIC] block namespaces
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Hannes Reinecke <hare@suse.de>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linux NVMe Mailinglist <linux-nvme@lists.infradead.org>
Date:   Thu, 10 Jun 2021 07:29:18 -0700
In-Reply-To: <539b35c6-34f7-62e0-4d93-6d27145bb78f@suse.de>
References: <a189ec50-4c11-9ee9-0b9e-b492507adc1e@suse.de>
         <485837f392401bf35fb7fc8231d7a051f47b53d7.camel@HansenPartnership.com>
         <539b35c6-34f7-62e0-4d93-6d27145bb78f@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-06-10 at 07:49 +0200, Hannes Reinecke wrote:
> On 6/9/21 8:36 PM, James Bottomley wrote:
> > On Thu, 2021-05-27 at 10:01 +0200, Hannes Reinecke wrote:
> > > Hi all,
> > > 
> > > I guess it's time to tick off yet another item on my long-term
> > > to-do list:
> > > 
> > > Block namespaces
> > > ----------------
> > > 
> > > Idea is similar to what network already does: allowing each user
> > > namespace to have a different 'view' on the existing block
> > > devices.  EG if the admin creates a ramdisk in one namespace this
> > > device should not be visible to other namespaces.  But for me the
> > > most important use-case would be qemu; currently the devices need
> > > to be set up in the host, even though the host has no business
> > > touching it as they really belong to the qemu instance.  This
> > > is causing quite some irritation eg when this device has LVM or
> > > MD metadata and udev is trying to activate it on the host.
> > 
> > I suppose the first question is "why block only?"  There are
> > several existing device namespace proposals which would be more
> > generic.
> > 
> 
> Well; I'm more of a storage person, and do know the needs and 
> shortcomings in that area. Less well so in other areas...

OK, but this should work for all devices, just like the device cgroup
if it's going to be an adjunct to it.

> > > Overall plan is to restrict views of '/dev', '/sys/dev/block' and
> > > '/sys/block' to only present the devices 'visible' for this
> > > namespace.
> > 
> > We actually already have a devices cgroup that does some of this:
> > 
> > https://www.kernel.org/doc/Documentation/cgroup-v1/devices.txt
> > 
> I know. But this essentially is a filter on '/dev' only, and needs to
> be configured. Which makes it very unwieldy to use.
> And the contents of sysfs are not modified, so there's a mismatch 
> between contents in /dev and /sys.
> Which might cause issues with monitoring tools.

Firstly, since it does part of what you want, we at least need to
understand why you think it can't be enhanced to do everything.

The /sys problem has been discussed many times.  GregKH really doesn't
like the idea of filtering /sys (and most container people agree), so
the options available seem to be don't mount /sys in a container or
emulate it via fuse.  If you pick either does the device cgroup now
work for you?

> > However, visibility isn't the only problem, for direct passthrough
> > there's also uevent handling and people have even asked about
> > module loading.
> > 
> I am aware, and that's another reason why device cgroup doesn't cut
> it.

Christian Brauner is looking at this ... apparently Ubuntu has some
thumb drive inside lxc container use case that needs it.

> > >   Initially the drivers would keep their global enumeration, but
> > > plan is to make the drivers namespace-aware, too, such that each
> > > namespace could have its own driver-specific device enumeration.
> > 
> > I really wouldn't do this.  Namespace/Cgroup separation should be
> > kept as high as possible.  If it leaks into the drivers it will
> > become unmaintainable.  Why do you think you need the drivers to be
> > aware?  If it's just enumeration, that should all be doable with
> > the visibility driver unless you want to do things like compact
> > numbering?
> > 
> Which is precisely why I mentioned device modifications.
> On a generic level we can influence the visibility of devices in 
> relation to namespaces, we cannot influence the devices themselves.
> This will lead to namespaces seeing disjunct device numbers (ie 8:0
> and 8:8 on ns 1, 8:4 on ns 2). Not that I think that will be an
> issue, but  certainly a change in behaviour.

Well, not necessarily, the pid namespace is an example of a remapping
namespace.  The same thing could be done for device numbering, but
there really needs to be a compelling case.  Given our use of hotplug,
why would any tool assume compact numbering?  And if you don't need
compact numbering there's no need to bother with remapping.

> > > Goal of this topic is to get a consensus on whether block
> > > namespaces are a feature which would find interest, and also to
> > > discuss some design details here:
> > > - Only in certain cases can a namespace be assigned (eg by
> > > calling
> > > 'modprobe', starting iscsiadm, or calling nvme-cli); how do we
> > > handle
> > > devices for which no namespace can be identified?
> > > - Shall we allow for different device enumeration per namespace?
> > > - Into which level should we go with hiding sysfs structures?
> > >    Is blanking out the higher-level interfaces in /dev and
> > > /sys/block    enough?
> > 
> > First question is does the device cgroup do enough for you and if
> > not what's missing?
> > 
> See above. sysfs modifications and uevent filtering are missing.
> This infrastructure for that is already in place thanks to network 
> namespaces, we 'just' need to make use of it.
> Additional drawback is the manual configuration of device-cgroup.

OK, so still, why not fix or enhance the device cgroup?  The current
proposal seems to want to duplicate it as a namespace.

James


