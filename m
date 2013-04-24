From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: T10 WCE interpretation in Linux & device level access
Date: Wed, 24 Apr 2013 23:54:21 +0200
Message-ID: <5178548D.6020805@redhat.com>
References: <5176E3E8.3000809@redhat.com> <1366747622.1939.6.camel@dabdike>  <5177BF53.3040305@redhat.com> <5177CAF5.6060506@suse.de>  <5177CB23.5090802@redhat.com> <5177CFB6.9070105@redhat.com>  <5177D6C2.6080705@redhat.com> <5177EDB5.5000105@tributary.com>  <8D3D17ACE214DC429325B2B98F3AE71293F3BBE2@MX15A.corp.emc.com>  <5178438F.3010103@gmail.com> <1366837373.1971.28.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:38540 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758005Ab3DXVyf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Apr 2013 17:54:35 -0400
Received: by mail-ea0-f170.google.com with SMTP id z7so946044eaf.15
        for <linux-scsi@vger.kernel.org>; Wed, 24 Apr 2013 14:54:33 -0700 (PDT)
In-Reply-To: <1366837373.1971.28.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ric Wheeler <ricwheeler@gmail.com>, "Black, David" <david.black@emc.com>, Jeremy Linton <jlinton@tributary.com>, Ric Wheeler <rwheeler@redhat.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "Knight, Frederick" <Frederick.Knight@netapp.com>

Il 24/04/2013 23:02, James Bottomley ha scritto:
> That just leaves us with random standards behaviour.  Lets permit the
> deterministic thing instead for the distros.  It kills two birds with
> one stone because we can set WCE for the stupid UAS devices that clear
> it wrongly as well.
> 
> For those who don't read code well, you add a temporary prefix to the
> cache set in
> 
> echo xxx > /sys/class/scsi_disk/<disk>/cache_type
> 
> and it will set the flags for the lifetime of the current kernel, but
> won't try to do a mode select to make them permanent.

Having the knob is useful indeed.  I don't like the "temporary" name
though, because "temporary write-through" doesn't sound like it can eat
data on a power loss.  What about "force" or "assume"?

Also, this would be in addition to my patch (when tested), right?

Paolo
