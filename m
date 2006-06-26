From: Andrew Morton <akpm@osdl.org>
Subject: Re: [RFC] [PATCH 2/2] kdump: cciss driver initialization
 issue fix
Date: Mon, 26 Jun 2006 10:24:10 -0700
Message-ID: <20060626102410.52070d7e.akpm@osdl.org>
References: <m1lkrjub2m.fsf@ebiederm.dsl.xmission.com>
	<E717642AF17E744CA95C070CA815AE550E1555@cceexc23.americas.cpqcorp.net>
	<20060626170440.GF8985@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <fastboot-bounces@lists.osdl.org>
In-Reply-To: <20060626170440.GF8985@in.ibm.com>
List-Unsubscribe: <https://lists.osdl.org/mailman/listinfo/fastboot>,
	<mailto:fastboot-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/fastboot>
List-Post: <mailto:fastboot@lists.osdl.org>
List-Help: <mailto:fastboot-request@lists.osdl.org?subject=help>
List-Subscribe: <https://lists.osdl.org/mailman/listinfo/fastboot>,
	<mailto:fastboot-request@lists.osdl.org?subject=subscribe>
Sender: fastboot-bounces@lists.osdl.org
Errors-To: fastboot-bounces@lists.osdl.org
To: vgoyal@in.ibm.com
Cc: Neela.Kolli@engenio.com, ebiederm@xmission.com, linux-scsi@vger.kernel.org, Mike.Miller@hp.com, fastboot@lists.osdl.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 26 Jun 2006 13:04:40 -0400
Vivek Goyal <vgoyal@in.ibm.com> wrote:

> > Thanks Eric, that helps me understand. Section 8.2.2 of the open cciss
> > spec supports a reset message. Target 0x00 is the controller. We could
> > add this to the init routine to ensure the board is made sane again but
> > this would drastically increase init time under normal circumstances.
> > And I suspect this is a hard reset, also. Not sure if that would
> > negatively impact kdump. If there were some condition we could test
> > against and perform the reset when that condition is met it would not
> > impact 99.9% of users.
> =

> That's the precise reason of introducing the "crashboot" command line
> parameter. Driver authors can check against this condition and reset
> the device and 99.9% of the users are not impacted.

Yes, that is a legitimate use.

As long as there is indeed a noticeable downside to issuing the reset - if
it turns out that it just takes a few milliseconds then we'd be better off
dong the reset unconditionally.
