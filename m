From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v4 0/3] qla2xxx: v3.4 target mode LLD changes +
 tcm_qla2xxx fabric module
Date: Mon, 14 May 2012 16:12:45 -0700
Message-ID: <1337037165.25759.393.camel@haakon2.linux-iscsi.org>
References: <4FAFD976.8090409@acm.org>
	 <1336966168.25759.293.camel@haakon2.linux-iscsi.org>
	 <4FB0FF99.8060307@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <4FB0FF99.8060307@acm.org>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, target-devel@vger.kernel.org, James Bottomley <jbottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-05-14 at 12:50 +0000, Bart Van Assche wrote:
> On 05/14/12 03:29, Nicholas A. Bellinger wrote:
> 
> > That would probably work, but I think it's still just a band-aid on the
> > underlying issue of SCSI LLDs always kicking off initiator mode enable /
> > disable operations from within PCI *_probe_one() / *_remove_code() code.
> 
> 
> Maybe the following makes sense (I'm not familiar with the qla2xxx
> driver nor with FC): split the qla2xxx driver in three kernel modules -
> a kernel module with the code that is shared by initiator and target
> mode, a kernel module with the initiator functionality and a kernel
> module with the target functionality. This will allow users to choose
> which functionality to enable by loading the proper kernel module(s).

Seriously, this involves high-level re-factoring of FC HBA drivers with
10x the moving parts and 100x the mission critical install base of your
other HW example.

So yes, wanting to re-factor logic out into common code for initiator /
target mode is good starting point, but without getting into the
real-deal FC HW specifics of how this would work for running code along
with tangible HBA vendor interest backing it, this type of statement
quickly falls into the realm of wishful thinking.

> Note: in the kernel module with the shared code an interface will have
> to be added that allows the initiator and the target module to enumerate
> qla2xxx HBA ports. Maybe it's a good idea to add an interface similar to
> the add_one() / remove_one() callback functions present in the Linux
> InfiniBand stack.
> 

Roland has had a few thoughts to this end about incremental improvements
post 3.5 merge, but the target team has been primarily interested in
fixing tcm_qla2xxx bugs and ensuring the qla2xxx LLD changes for target
mode do not cause FC initiator mode regressions.  

Considering the time scales involved with doing this type of testing
(esp the latter, which can take months) plus given the amount of LLD
code involved (40K LOC), a large re-org that effects existing FC
initiator mode operation is something we'd like to avoid for now.

Thanks,

--nab
