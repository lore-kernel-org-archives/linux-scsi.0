From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Thu, 5 Mar 2015 17:06:47 +0100
Message-ID: <54F87F17.30207@sandisk.com>
References: <54B7E70C.8020304@sandisk.com>
 <20150119092153.GA8666@infradead.org> <54BCD00D.4080603@sandisk.com>
 <54E7112F.2080901@sandisk.com>
 <1424476807.1477.52.camel@haakon3.risingtidesystems.com>
 <54ED8B38.10904@sandisk.com>
 <1425074315.30923.74.camel@haakon3.risingtidesystems.com>
 <54F1ADAF.90808@sandisk.com>
 <1425279574.13530.53.camel@haakon3.risingtidesystems.com>
 <54F6DD3B.4030207@sandisk.com> <20150305132337.GA32341@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0072.outbound.protection.outlook.com ([157.56.111.72]:4320
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757178AbbCEQG4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2015 11:06:56 -0500
In-Reply-To: <20150305132337.GA32341@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Dr. Greg Wettstein" <greg@wind.enjellic.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/05/15 14:23, Christoph Hellwig wrote:
> This is exactly why I didn't want to put this topic onto the LSF agenda.
> 
> There are tons of very useful fixes and cleanus in Barts series, and I'd
> really like to get them in ASAP.
> 
> As Nic pointed out (in a slightly unhelpful tone) we're not interested
> in adding any hooks for out of tree code.  But if SCST needs hooks it
> should eithe switch to the in-kerel way of doing it, or if has a clearly
> better way of doing it merge that into the kernel.  I'm pretty sure
> there are various pieces that would make a lot of sense to merge either
> way, and getting towards a single target with a broad maintainer and
> user base seem like a way better approach that adding weird hooks.  But
> I don't think that's even on the table for LSF this year, maybe next
> year if everyone involved works hard on it.

Hello Christoph,

If we would do what Nic proposed - modify SCST such that it uses
configfs instead of sysfs - then that would result in the removal of at
least one SCST feature that is important to its users, namely automatic
population of the configuration filesystem with hardware target port
information. Apparently Nic does not want to convert LIO from configfs
to sysfs. The reason I proposed to add empty transport_register_wwn()
and transport_unregister_wwn() functions in the LIO core is because this
allows LIO to keep using configfs and does not require to remove
features from SCST. BTW, a message that was posted four years ago on the
linux-scsi mailing list contains an excellent explanation of why sysfs
has been chosen for the SCST user space API. From
http://thread.gmane.org/gmane.linux.scsi/65615/focus=65618: <quote>
I think the overall philosophical point here, and it's a good one
because I've heard it from several sources, is that it's not possible to
separate configuration from status completely.  The classic example is
where the kernel has to validate and adjust config information, but the
storage specific one is where events alter the topology.  In either
case, the configfs tree gets out of sync with reality if the kernel does
the adjustment..  Just saying we have to use a user space tool to fix it
up is a bit of a cop out because the kernel has already adjusted its own
configuration, so getting userspace to work out what the kernel's done
and adjust configfs is a bit sub optimal.</quote>

Bart.
