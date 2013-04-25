From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: T10 WCE interpretation in Linux & device level access
Date: Wed, 24 Apr 2013 21:32:51 -0400
Message-ID: <yq17gjrv1h8.fsf@sermon.lab.mkp.net>
References: <5176E3E8.3000809@redhat.com> <1366747622.1939.6.camel@dabdike>
	<5177BF53.3040305@redhat.com> <5177CAF5.6060506@suse.de>
	<5177CB23.5090802@redhat.com> <5177CFB6.9070105@redhat.com>
	<5177D6C2.6080705@redhat.com> <5177EDB5.5000105@tributary.com>
	<8D3D17ACE214DC429325B2B98F3AE71293F3BBE2@MX15A.corp.emc.com>
	<5178438F.3010103@gmail.com> <1366837373.1971.28.camel@dabdike>
	<5178548D.6020805@redhat.com> <1366841383.1971.36.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17943 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758717Ab3DYBdN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Apr 2013 21:33:13 -0400
In-Reply-To: <1366841383.1971.36.camel@dabdike> (James Bottomley's message of
	"Wed, 24 Apr 2013 15:09:43 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <ricwheeler@gmail.com>, "Black, David" <david.black@emc.com>, Jeremy Linton <jlinton@tributary.com>, Ric Wheeler <rwheeler@redhat.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "Knight, Frederick" <Frederick.Knight@netapp.com>

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> I'm fairly ambivalent, except not force.  The default behaviour
James> is to do the mode select, so force seems to imply that as well,
James> except it won't.  I don't see a difference between assume and
James> temporary.

I'm ok with your patch. And a strong believer in not altering the
SYNCHRONIZE CACHE behavior that's been rigorously tested in the field by
adding SYNC_NV to the mix.


James> Not really ... given T10s deprecation I don't think we want to
James> touch anything to do with SYNC_NV because it just adds to the
James> uncertainty about what will actually happen.  

Yep.


James> Giving the ability to control WCE (and RCD) fixes all the
James> problems raised so far.

If there are devices that would truly benefit from SYNC_NV we could add
a sync_nv parameter to scsi_disk's sysfs that could be used to set that
bit when issuing flush_cmnd.

But it would be something we would do manually on a per-device basis and
not something that is automatically keyed off of NV_SUP (SYNC_NV doesn't
require NV_SUP, btw., so that's not even a valid check).

-- 
Martin K. Petersen	Oracle Linux Engineering
