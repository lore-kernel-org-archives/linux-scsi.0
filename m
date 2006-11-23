From: "Yinghai Lu" <yinghai.lu@amd.com>
Subject: Re: [PATCH 4/5] e1000 : Make Intel e1000 driver
	legacy I/O port free
Date: Wed, 22 Nov 2006 22:16:07 -0800
Message-ID: <86802c440611222216u629835fepe2a39d4d34d9fefb@mail.gmail.com>
References: <4564050C.70607@jp.fujitsu.com>
	<1164185809.31358.714.camel@laptopd505.fenrus.org>
	<20061122135423.GV18567@parisc-linux.org> <456476B0.70705@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <e1000-devel-bounces@lists.sourceforge.net>
In-Reply-To: <456476B0.70705@intel.com>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=e1000-devel>
List-Post: <mailto:e1000-devel@lists.sourceforge.net>
List-Help: <mailto:e1000-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/e1000-devel>,
	<mailto:e1000-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: e1000-devel-bounces@lists.sourceforge.net
Errors-To: e1000-devel-bounces@lists.sourceforge.net
To: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Andrew Morton <akpm@osdl.org>, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, Grant Grundler <grundler@parisc-linux.org>, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, e1000-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, linux-pci@atrey.karlin.mff.cuni.cz, Arjan van de Ven <arjan@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 11/22/06, Auke Kok <auke-jan.h.kok@intel.com> wrote:
> I think we want to condense the USE_IOPORT flag together with the other hardware

two cases
1. the IO port is not allocated by firmware, but
pci_assign_unassigned_resources will get that allocated.
2. the IO port is allocated by firmware, the bar will be retrieved by
pcibios_resource_survey.

so acctully the device already get the bar allocated in any case.

So what the purpose of this patch? the /poc/ioports hide ioport for the driver?

It seems need to add some pci_quirk to clear the bar for 2, and skip
the resource allocation for 1.

YH

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
