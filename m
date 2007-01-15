From: "=?UTF-8?Q?Kristian_H=C3=B8gsberg?=" <krh@bitplanet.net>
Subject: Re: [PATCH] ieee1394: sbp2: lower block queue alignment requirement
Date: Mon, 15 Jan 2007 14:39:10 -0500
Message-ID: <59ad55d30701151139w6176e785g53404d7b3a42ce6e@mail.gmail.com>
References: <tkrat.37326df2d568d12d@s5r6.in-berlin.de>
	<1168802387.2780.1.camel@mulgrave.il.steeleye.com>
	<tkrat.cad61efa52eb6e56@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.cad61efa52eb6e56@s5r6.in-berlin.de>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 1/14/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> On 14 Jan, James Bottomley wrote:
> > The block layer currently provides sector (512) byte alignment
> > guarantees.  However, there has been talk in SCSI of reducing that to
> > word (4) since that's what most intelligent PCI controllers can cope
> > with.  If you have any alignment constraints, they should be expressed
> > in the slave configure.
>
> OK, thanks. I will keep the explicit setting of the mask then.
> I actually think that everything should work just fine with 4 bytes
> alignment, but the SBP-2 spec mentiones 8 bytes alignment for the S/G
> tables.  So maybe device firmwares will expect it that way even though
> IEEE 1394 doesn't impose such a restriction even on transfers with a
> payload of a multiple of 8 bytes.

Do you have a reference to this 8 byte alignment requirement?  I
couldn't find it browsing through the standard.  Also, since the SBP-2
driver has to  convert the scatterlist to an SBP-2 page table, it can
just allocate the page table on a 8-byte boundary if that is required.
 The entries in the scatter table have no alignment restrictions from
the SBP-2 side.

By the way, is there a way to ask the SCSI stack to limit the size of
the entries in the scatterlist to 64k?  This would greatly simplify
the conversion to SBP-2 page tables, since this is the maximum size
these can hold.

cheers,
Kristian

-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
