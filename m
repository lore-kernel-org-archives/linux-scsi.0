From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Booting from Qlogic qla2300 fibre channel card
Date: Wed, 16 Apr 2003 09:10:55 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030416091055.A4351@beaverton.ibm.com>
References: <20030416061830.GA30423@quadpro.stupendous.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030416061830.GA30423@quadpro.stupendous.org>; from jurjen@quadpro.stupendous.org on Wed, Apr 16, 2003 at 08:18:30AM +0200
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 16, 2003 at 08:18:30AM +0200, Jurjen Oskam wrote:

> The storage array is an EMC Symmetrix model 8530. EMC created a document
> where they explain how to make such a configuration work. When they mention
> booting from a Symmetrix-provided volume, they mention the following:
> 
> "If Linux loses connectivity long enough, the disks disappear from the
> system. [...] For [this reason], EMC recommends that you do not boot a
> Linux host from the EMC storage array."

That probably means the EMC is returning a vendor specific (or perhaps even
a standard) sense code, you'd have to ask EMC specifically what they mean,
and what sense code is returned, or maybe check the logs on your other box
for specifics.

This also means that changing the scsi timeout will have no affect, since
the IO will complete without timing out.

See scsi_error.c scsi_check_sense for how they are handled. One important
piece is that the VENDOR SPECIFIC sense key (value of 9 in
sense_buffer[2]) falls into the default case of SUCCESS (i.e. complete the
IO as failed). Whatever (and if) the code is, you would effectively want
scsi_check_sense to return NEEDS_RETRY rather than SUCCESS.

There is also some range (can't remember what, or where they are in the
SCSI spec) for vendor specific ASC/ASCQ for any (or all?) sense keys.

We don't have a way (2.4 or 2.5) to dynamically (and cleanly) add vendor
specific sense codes and handling of them.

> When making an online configuration change on the Symmetrix (such as
> remapping volumes), it is possible for the attached hosts to experience
> a temporary error while accessing a storage array volume. For example,
> when changing the Symmetrix configuration, it is not uncommon for the
> RS/6000s (also attached to the SAN) to log one or two temporary
> SCSI-errors. They don't cause any problems at all, the AIX volume manager
> never notices a problem.


> Does the warning describe a real-world possibility? For example, what is
> "long enough"?

Long enough probably means long enough for any IO to be sent to the EMC.

-- Patrick Mansfield
