From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] Change signal used to exit scsi error handlers
Date: Wed, 8 Jan 2003 15:36:10 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030108233610.GH1112@beaverton.ibm.com>
References: <20030101210555.GS1378@linnie.riede.org> <20030108225302.GE1378@linnie.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030108225302.GE1378@linnie.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>
Cc: linux-scsi@vger.kernel.org

Willem Riede [wrlk@riede.org] wrote:
> On 2003.01.01 16:05 Willem Riede wrote:
> > I earlier reported, that the error handler for ide-scsi exits prematurely if modprobed
> > from rc.sysinit. I put in some debug prints to apprehend the culprit responsible for
> > sending the SIGHUP signal that causes the exit.
> > 
> [snip]
> > 
> > Since we want error handlers to survive, IMHO that means that the choice of signal
> > for error handler exit is unfortunate. The source of scsi_error suggests SIGPWR
> > might be a worthy alternative. I think that is true. From inspecting init source,
> > it is not capable of sending SIGPWR. SIGPWR should never be sent by dying processes
> > (its sole use should be from a power daemon _to_ init to shut the system down when
> > the juice is running out).
> > 
> So nobody has any comments? But who decides whether to make this change?
> >From the source it appears that the last person to touch scsi_error.c and hosts.c
> is Mike Anderson. Does that make you the defacto maintainer, Mike?

Sorry about no reply I am just back from a very long time out of the
office and I am just catching up.

I do not know if last updates give me maintainership, but I will give
my $.02.

The change looks reasonable to switch to another signal to avoid the
problem. It is unclear why the comment mentioned only SIGPWR as the only
alternative. It would think that SIGUSR1, SIGUSR2, etc. would also work
maybe someone else on this list or linux-kernel would know why.

The logging change looks good.

-andmike
--
Michael Anderson
andmike@us.ibm.com

