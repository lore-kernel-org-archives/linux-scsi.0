From: Andrew Morton <akpm@osdl.org>
Subject: Re: [RFC] [PATCH 2/2] kdump: cciss driver initialization
 issue fix
Date: Mon, 26 Jun 2006 10:31:30 -0700
Message-ID: <20060626103130.de79fd9f.akpm@osdl.org>
References: <20060623235553.2892f21a.akpm@osdl.org>
	<20060624111954.GA7313@in.ibm.com>
	<20060624043046.4e4985be.akpm@osdl.org>
	<20060624120836.GB7313@in.ibm.com>
	<m1veqqxyrb.fsf@ebiederm.dsl.xmission.com>
	<20060626021100.GA12824@in.ibm.com>
	<20060626133504.GA8985@in.ibm.com>
	<m11wtcvw5k.fsf@ebiederm.dsl.xmission.com>
	<20060626153239.GD8985@in.ibm.com>
	<m13bdrvrd4.fsf@ebiederm.dsl.xmission.com>
	<20060626171659.GG8985@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <fastboot-bounces@lists.osdl.org>
In-Reply-To: <20060626171659.GG8985@in.ibm.com>
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
Cc: Neela.Kolli@engenio.com, ebiederm@xmission.com, mike.miller@hp.com, linux-scsi@vger.kernel.org, fastboot@lists.osdl.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 26 Jun 2006 13:16:59 -0400
Vivek Goyal <vgoyal@in.ibm.com> wrote:

> So it is matter of making a choice in case the device does not have a
> software reset capability.
> =

> - Either try to make driver work through some hacks based on crashboot
>   option.
> =

> - Or mark the driver unusable in kdump scenarios.
> =

> Even if one decides to go for second option, at least "crashboot" or
> similar parameter will be required so that driver can choose whether
> to reset the device or not during initialization due to significant
> time penalty. =


yes, this does legitimise the `crashboot' option.

That being said, it's misnamed, I think.  It should be called
`reset_devices' or something.  Because that's what it does, and who
knows, there might be other reasons for wanting to reset devices.

See, it's more accurate.  We don't want drivers to be looking at some
global environmental thing and then independently working out what they
should be doing this time around.  We just want drivers to do what they're
told.
