From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 09/14] target/configfs: Expose protection device
 attributes
Date: Mon, 13 Jan 2014 11:43:11 -0800
Message-ID: <1389642191.12062.32.camel@dabdike.int.hansenpartnership.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	 <1389212157-14540-10-git-send-email-nab@daterainc.com>
	 <yq161prr1p8.fsf@sermon.lab.mkp.net>
	 <1389637859.5567.431.camel@haakon3.risingtidesystems.com>
	 <1389639177.12062.21.camel@dabdike.int.hansenpartnership.com>
	 <1389641243.5567.445.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45700 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbaAMTnN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jan 2014 14:43:13 -0500
In-Reply-To: <1389641243.5567.445.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>

On Mon, 2014-01-13 at 11:27 -0800, Nicholas A. Bellinger wrote:
> On Mon, 2014-01-13 at 10:52 -0800, James Bottomley wrote:
> > On Mon, 2014-01-13 at 10:30 -0800, Nicholas A. Bellinger wrote:
> > > Hey MKP,
> > > 
> > > On Fri, 2014-01-10 at 16:01 -0500, Martin K. Petersen wrote:
> > > > >>>>> "nab" == Nicholas A Bellinger <nab@daterainc.com> writes:
> > > > 
> > > > nab> This patch adds support for exposing DIF protection device
> > > > nab> attributes via configfs.  This includes:
> > > > 
> > > > nab>    pi_prot_type: Protection Type (0, 1, 3 currently support)
> > > > nab>    pi_prot_version: Protection Version (DIF v1 currently supported)
> > > > 
> > > > What's DIF v2?
> > > > 
> > > 
> > > This would be the proposed 16-byte protection scheme for SBC4.
> > 
> > What proposed 16 byte scheme?  The only DIF proposals I know for SBC-4
> > are 13-185R0 and 12-369R0 and that's a couple of new algorithms and
> > types because we cannot change the 8 byte PI.
> > 
> 
> Then I'm probably getting the SBC version wrong..  It's the one that
> includes using CRC32C for the block guard, and larger space for
> reference tag as mentioned by MKP.

Well, this isn't reducing my confusion:  I think you're referring to
12-369r0 which proposes to *eliminate* the reference tag (by moving it
into the CRC calculation) and use the recovered 4 bytes to expand the
CRC to CRC32 and add two bytes to the application tag, so they both
become 4 bytes long, but the new PI still occupies only 8 bytes on disk.

Perhaps it's also better to clarify the terminology:  The PI is composed
of a Guard field, which is the checksum, an application tag, which is
usable by the application for anything it wants and a reference tag
which is designed to be derived from the on-disk location so it can be
used to detect misplaced writes.  In Type 1 the reference tag has to be
the lower 31 bits of the LBA and in type 3 it's application defined.  In
all current types, the guard is two bytes and the application tag two
bytes.

James


