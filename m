From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v3 13/13] cxgbit: add files for cxgbit.ko
Date: Mon, 23 May 2016 23:40:25 -0700
Message-ID: <1464072025.22249.87.camel@haakon3.risingtidesystems.com>
References: <cover.1461088672.git.varun@chelsio.com>
	 <62c9d9c1e609c39f714ef15c10ba62b1cbbddecd.1461088673.git.varun@chelsio.com>
	 <CAJ3xEMiyQaWwsgVd_J9eVXqPwPk6=VYN_iMoEJQGz=1wHFrHqQ@mail.gmail.com>
	 <CAJ3xEMgtsPiatZ-Cy2ENsGVyKVDQSSHi4jr0Ushg21JiuqdLcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAJ3xEMgtsPiatZ-Cy2ENsGVyKVDQSSHi4jr0Ushg21JiuqdLcw@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: target-devel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, kxie@chelsio.com, indranil@chelsio.com, Steve Wise <swise@opengridcomputing.com>, Varun Prakash <varun@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

Hi Or & Co,

On Wed, 2016-05-18 at 14:45 +0300, Or Gerlitz wrote:
> On Sat, Apr 30, 2016 at 6:54 PM, Or Gerlitz <gerlitz.or@gmail.com> wrote:
> > On Tue, Apr 19, 2016 at 9:30 PM, Varun Prakash <varun@chelsio.com> wrote:
> >> cxgbit.h - This file contains data structure
> >> definitions for cxgbit.ko.
> >>
> >> cxgbit_lro.h - This file contains data structure
> >> definitions for LRO support.
> >>
> >> cxgbit_main.c - This file contains code for
> >> registering with iscsi target transport and
> >> cxgb4 driver.
> >>
> >> cxgbit_cm.c - This file contains code for
> >> connection management.
> >>
> >> cxgbit_target.c - This file contains code
> >> for processing iSCSI PDU.
> >>
> >> cxgbit_ddp.c - This file contains code for
> >> Direct Data Placement.
> >
> > Wait,
> >
> > You are adding many K's LOCs to handle things like CM (connection
> > management), DDP and LRO. But your upstream solution must be using CM
> > and DDP (and LRO as well) for the HW offloaded initiator side as well,
> > not to mention the iWARP side of things.
> >
> > There must be some way to refactor things instead of repeating the
> > same bits over and over, thoughts?
> 
> Nic,
> 
> The author haven't responded... where that this stands from your point of view?
> 

For an initial merge, I don't have an objection to this series wrt
drivers/target/iscsi/* improvements + prerequisites, and new standalone
cxgbit iscsit_transport driver.

That said, there are areas between cxgbi + cxgbit code that can be made
common as you've pointed out.  The Cheliso folks have mentioned off-list
that cxgbi as-is in mainline does not support LRO, and that the majority
of DDP logic is shared between initiator + target.

Are there specific pieces of logic in DDP or iWARP for cxgb* that you'd
like to see Varun + Co pursue as common code in v4.8+..?
