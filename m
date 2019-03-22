From: Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 0/2] Remove support for deprecated %pf and %pF in vsprintf
Date: Fri, 22 Mar 2019 15:53:50 +0200
Message-ID: <20190322135350.2btpno7vspvewxvk@paasikivi.fi.intel.com>
References: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
 <CAMuHMdVmqqjVx7As9AAywYxYXG=grijF5rF77OBn6TUjM9+xKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAMuHMdVmqqjVx7As9AAywYxYXG=grijF5rF77OBn6TUjM9+xKw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Linux PM list <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MMC List <linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ACPI Devel Maling List <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux ARM <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sparclinux <sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, ceph-devel <ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-btrfs <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Geert,

On Fri, Mar 22, 2019 at 02:37:18PM +0100, Geert Uytterhoeven wrote:
> Hi Sakari,
> 
> On Fri, Mar 22, 2019 at 2:25 PM Sakari Ailus
> <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > The printk family of functions supports %ps and %pS conversion specifiers
> > to print function names. Yet the deprecated %pf and %pF conversion
> > specifiers with equivalent functionality remain supported. A number of
> > users of %pf and %pF remain.
> >
> > This patchsets converts the existing users of %pf and %pF to %ps and %pS,
> > respectively, and removes support for the deprecated %pf and %pF.
> >
> > The patches apply cleanly both on 5.1-rc1 as well as on Linux-next. No new
> > %pf or %pF users have been added in the meantime so the patch is
> > sufficient as itself on linux-next, too.
> 
> Do you know in which commit they became deprecated, so the backporters
> know how far this can be backported safely?

That appears to be 04b8eb7a4ccd
("symbol lookup: introduce dereference_symbol_descriptor()"), the same
patch that made %p[fF] and %p[sS] functionally equivalent.

But my personal opinion would be not to backport the patch for two reasons:
the sheer number of files it touches (those format strings change for
various reasons) and the meager benefits it has on older kernels as any
backported patch using %s or %S still works as such. Porting a patch
forward should have no issues either as checkpatch.pl has been complaining
of the use of %pf and %pF for a while now.

-- 
Kind regards,

Sakari Ailus
sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
