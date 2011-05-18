From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: RE: [PATCH 1/3] mpt2sas: remove the use of writeq, since writeq is
	not atomic
Date: Thu, 19 May 2011 07:30:18 +1000
Message-ID: <1305754218.7481.0.camel@pasglop>
References: <20110504115324.GE17855@lsi.com>
	<1305616571.6008.23.camel@mulgrave.site>
	<B2FD678A64EAAD45B089B123FDFC3ED70157F7BCE5@inbmail01.lsi.com>
	<20110518041551.GL15227@parisc-linux.org>
	<1305692584.2580.3.camel@mulgrave.site>	<1305702010.2781.33.camel@pasglop>
	<mpt2sas-writeq-powerpc64@mdm.bga.com>
	<4565AEA676113A449269C2F3A549520F80B66280@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <4565AEA676113A449269C2F3A549520F80B66280@cosmail03.lsi.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "Desai,
	Kashyap" <Kashyap.Desai@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>, Milton Miller <miltonm@bga.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "paulus@samba.org" <paulus@samba.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-05-18 at 09:35 -0600, Moore, Eric wrote:
> I worked the original defect a couple months ago, and Kashyap is now
> getting around to posting my patch's.
> 
> This original defect has nothing to do with PPC64.  The original
> problem was only on x86.    It only became a problem on PPC64 when I
> tried to fix the original x86 issue by copying the writeq code from
> the linux headers, then it broke PPC64.   I doubt that broken patch
> was ever posted. Anyways, back to the original defect.  The reason it
> because a problem for x86 is because the kernel headers had a
> implementation of writeq in the arch/x86 headers, which means our
> internal implementation of writeq is not being used.  The writeq
> implementation in the kernel is total wrong for arch/x86 because it
> doesn't not have spin locks, and if two processor simultaneously doing
> two separate 32bit pci writes, then what is received by controller
> firmware is out of order.   This change occurs between Red Hat RHEL5
> and RHEL6.  In RHEL5, this writeq was not implemented in arch/x86
> headers, and our driver internal implementation of write was used.

You may also want to look at Milton's comments, it looks like the way
you do init_completion followed immediately by wait_completion is racy.

You should init the completion before you do the IO that will eventually
trigger complete() to be called.

Cheers,
Ben.
