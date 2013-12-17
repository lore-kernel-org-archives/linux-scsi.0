From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 6/8] target_core_spc: Include target device descriptor
 in VPD page 83
Date: Tue, 17 Dec 2013 12:01:45 -0800
Message-ID: <1387310505.20247.309.camel@haakon3.risingtidesystems.com>
References: <1387268330-121064-1-git-send-email-hare@suse.de>
	 <1387268330-121064-7-git-send-email-hare@suse.de>
	 <1387309849.20247.306.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1387309849.20247.306.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-12-17 at 11:50 -0800, Nicholas A. Bellinger wrote:
> On Tue, 2013-12-17 at 09:18 +0100, Hannes Reinecke wrote:
> > We should be including a descriptor referring to the target device
> > to allow identification of different TCM instances.
> > 
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > ---
> >  drivers/target/target_core_spc.c | 43 +++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 42 insertions(+), 1 deletion(-)
> > 
> 
> One issue with this patch.  The local buffer in spc_emulate_inquiry is
> currently hardcoded to SE_INQUIRY_BUF=512, so two large scsi name
> designators could overflow here..
> 
> So for the largest case with EVPD=0x83, this would be:
> 
> 4 bytes for header +
> 20 bytes for NAA IEEE Registered Extended Assigned designator +
> 56 bytes for T10 Vendor Identifier +
> 8 bytes for Relative target port +
> 8 bytes for Target port group +
> 8 bytes for Logical unit group +
> 256 bytes for SCSI name (target port) +
> 256 bytes for SCSI name (target device) == 616 bytes.
> 
> So for good measure, bumping up SE_INQUIRY_BUF to 1024.
> 

Mmmm, looking at this again, is reporting back two SCSI names in
EVPD=0x83 with different associations (one for target port, and one for
target device) really necessary..?

Doesn't the existing target port association report back the same
information..?

--nab
