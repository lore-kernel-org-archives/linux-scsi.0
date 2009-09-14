From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: MD/RAID time out writing superblock
Date: Mon, 14 Sep 2009 15:14:38 +0200
Message-ID: <20090914131438.GD14072@boogie.lpds.sztaki.hu>
References: <1571f45804875514762f60c0097171e6@localhost>
 <d086b110526f8bac2f562850dfc70b03@localhost>
 <4A970154.2020507@redhat.com>
 <4A9B8583.9050601@kernel.org>
 <4A9BBC4A.6070708@redhat.com>
 <4A9BC023.10903@kernel.org>
 <20090907114442.GG18831@arachsys.com>
 <20090907115927.GU8710@arachsys.com>
 <20090909120218.GB21829@arachsys.com>
 <4AADF3C4.5060004@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:34793 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbZINNYs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2009 09:24:48 -0400
Content-Disposition: inline
In-Reply-To: <4AADF3C4.5060004@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Chris Webb <chris@arachsys.com>, linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>

On Mon, Sep 14, 2009 at 04:41:56PM +0900, Tejun Heo wrote:

> Because this error is actually seen by the md layer and FLUSH in
> general can't be retried cleanly.  On retrial, the drive goes on and
> retry the sectors after the point of failure.  I'm not sure whether
> FLUSH is actually failing here or it's a communication glitch.  At any
> rate, if FLUSH is failing or timing out, the only right thing to do is
> to kick it out of the array as keeping after retrying may lead to
> silent data corruption.

Hmm, how's that supposed to work with TLER on WD enterprise drives?
Isn't the idea behind TLER to prevent drives being kicked out of the
array because the RAID system can have a much more intelligent
retry/recovery logic than a single drive?

AFAIK md RAID can already take advantage of TLER if the operation that's
failing due to TLER is a READ, but I don't know what happens if TLER
kicks in during a WRITE or a FLUSH.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
