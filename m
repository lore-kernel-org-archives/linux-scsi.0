From: Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: [RFC] [PATCH 2/2] kdump: cciss driver initialization
	issue fix
Date: Mon, 26 Jun 2006 14:18:25 -0400
Message-ID: <20060626181825.GI8985@in.ibm.com>
References: <E717642AF17E744CA95C070CA815AE550E1555@cceexc23.americas.cpqcorp.net>
	<m1veqnst2b.fsf@ebiederm.dsl.xmission.com>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <fastboot-bounces@lists.osdl.org>
Content-Disposition: inline
In-Reply-To: <m1veqnst2b.fsf@ebiederm.dsl.xmission.com>
List-Unsubscribe: <https://lists.osdl.org/mailman/listinfo/fastboot>,
	<mailto:fastboot-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/fastboot>
List-Post: <mailto:fastboot@lists.osdl.org>
List-Help: <mailto:fastboot-request@lists.osdl.org?subject=help>
List-Subscribe: <https://lists.osdl.org/mailman/listinfo/fastboot>,
	<mailto:fastboot-request@lists.osdl.org?subject=subscribe>
Sender: fastboot-bounces@lists.osdl.org
Errors-To: fastboot-bounces@lists.osdl.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>, Neela.Kolli@engenio.com, "Miller,
	Mike (OS Dev)" <Mike.Miller@hp.com>, linux-scsi@vger.kernel.org, fastboot@lists.osdl.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 26, 2006 at 11:52:28AM -0600, Eric W. Biederman wrote:
> "Miller, Mike (OS Dev)" <Mike.Miller@hp.com> writes:
> =

> > Thanks Eric, that helps me understand. Section 8.2.2 of the open cciss
> > spec supports a reset message. Target 0x00 is the controller. We could
> > add this to the init routine to ensure the board is made sane again but
> > this would drastically increase init time under normal circumstances.
> =

> Where does the init time penalty come from? How large is the
> init penalty?  I suspect it is from waiting for the scsi disks to spin up.
> But I am just guessing in the dark.
> =

> > And I suspect this is a hard reset, also. Not sure if that would
> > negatively impact kdump. If there were some condition we could test
> > against and perform the reset when that condition is met it would not
> > impact 99.9% of users.
> =

> I am wondering if it is possible to look at the controller and
> see if it is in a bad state, (i.e. in some state besides just coming
> out of reset) and if so issue a reset.  If this really is a long operation
> that would be the ideal way to handle it.
> =


That's a good question. MPT fustion driver already does something like
this. It retrieves the state of IOC and then checks whether there is
a need of reset or not.

        /*
         *      Check to see if IOC got left/stuck in doorbell handshake
         *      grip of death.  If so, hard reset the IOC.
         */
        if (ioc_state & MPI_DOORBELL_ACTIVE) {
                statefault =3D 1;
                printk(MYIOC_s_WARN_FMT "Unexpected doorbell active!\n",
                                ioc->name);
        }

But then question will be if all the devices out there provide the
capability to query something similar to if we have just come out of reset
state or not.

> If the amount of time is really user noticeable and testing for it
> is impossible then it is probably time to talk kernel command line
> options.  > =

> Although it might simply be appropriate to handle commands completing
> you didn't start.  I am not at all familiar with that particular piece
> of hardware so I can't make a good guess on what needs to happen there.
> =

> > Thoughts, comments, flames?
> =

> Good question.
> =

> It is a bit of a pain but not too hard to setup a test environment
> so you can reproduce this if you are interested.  Vivek should
> be the authority there.
> =


Mike, I have got one setup ready with me. I have got a Compaq Smart Array
5300 controller. I can reproduce this issue consistently. I don't know
much about this device. Is it possible for you to post a patch for =

resetting the device during initialization. I can test the fix and provide
you more data.

Thanks
Vivek =
