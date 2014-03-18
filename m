From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 00/12] scsi/NCR5380: fix debugging macros and #include
 structure
Date: Tue, 18 Mar 2014 06:07:31 -0700
Message-ID: <1395148051.2812.51.camel@joe-AO722>
References: <20140318002822.372705594@telegraphics.com.au>
 <1395112756.20860.1.camel@joe-AO722>
 <alpine.LNX.2.00.1403182208590.2018@nippy.intranet>
 <1395146702.2812.47.camel@joe-AO722>
 <CAMuHMdUMpdp7deL5zC4hUVTHjyNbtkZ2bNFupo5JiDyuyc345w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAMuHMdUMpdp7deL5zC4hUVTHjyNbtkZ2bNFupo5JiDyuyc345w@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Creasey <sammy@sammy.net>, Linux/m68k <linux-m68k@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>, scsi <linux-scsi@vger.kernel.org>, Michael Schmitz <schmitz@debian.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Finn Thain <fthain@telegraphics.com.au>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2014-03-18 at 13:55 +0100, Geert Uytterhoeven wrote:
> On Tue, Mar 18, 2014 at 1:45 PM, Joe Perches <joe@perches.com> wrote:

Hi Geert.

> > #define dprintk(flg, fmt, ...) \
> > do { if (0) pr_debug(fmt, ##__VA_ARGS__); } while (0)
> 
> Na, no_printk():
> 
> #define dprintk(flg, fmt, ...) no_printk(fmt, ##__VA_ARGS__)

Fine, but with a correction.

no_printk keeps all side effects like
performing any function calls made by the
statement or accessing any volatiles.

Using

do { if (0) no_printk(fmt, ##__VA_ARGS__); } while (0)

does not have any side-effects.
