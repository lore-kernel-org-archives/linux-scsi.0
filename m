From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH / RFC] scsi_set_host_offline
Date: Tue, 4 Mar 2003 14:29:07 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030304222907.GA1252@beaverton.ibm.com>
References: <20030303221532.GB1587@beaverton.ibm.com> <200303040103.18491.oliver@neukum.name> <20030304123605.D6452@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030304123605.D6452@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>, linux-scsi@vger.kernel.org

Matthew Dharm [mdharm-scsi@one-eyed-alien.net] wrote:
> On Tue, Mar 04, 2003 at 01:03:18AM +0100, Oliver Neukum wrote:
> > Don't we need to disallow further devices being discovered on this
> > host's busses before we set the existing devices offline?
> 
> Hrm... yes, I think this could be a problem.
> 
> For 99% of USB storage devices, it's not.  One device == one host with one
> target.  However, for the other 1% of devices (and all 'real' SCSI hosts),
> this could be an issue.  I could be trying to yank the device (hot-unplug)
> at the same moment someone is doing an add-single-device.
> 

While the calling of scsi_set_host_offline may mean no more additions
for a set of hosts it may be not be the case for the whole set.

A host offline value may be a good thing to add. The policy around the
state maybe hard to generalize.

If a LLDD decided that it did not want any more devices added it can
today fail calls to queuecommand or slave_alloc (which some already do).
The LLDD may need to handle these in the future depending on what
functions scsi_set_host_offline maybe racing with.

-andmike
--
Michael Anderson
andmike@us.ibm.com

