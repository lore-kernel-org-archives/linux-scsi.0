From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [KJ] [PATCH][RESUBMIT][11/21] drivers/scsi/* - compile warning
	cleanup
Date: Tue, 15 Feb 2005 14:09:02 +0000
Message-ID: <20050215140902.GM29917@parcelfarce.linux.theplanet.co.uk>
References: <42113C2D.5008.52BF1B@localhost>
	<20050215103959.GB19930@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============00074499819452578109=="
In-Reply-To: <20050215103959.GB19930@infradead.org>
List-Unsubscribe: <http://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/kernel-janitors>
List-Post: <mailto:kernel-janitors@lists.osdl.org>
List-Help: <mailto:kernel-janitors-request@lists.osdl.org?subject=help>
List-Subscribe: <http://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=subscribe>
Sender: kernel-janitors-bounces@lists.osdl.org
Errors-To: kernel-janitors-bounces@lists.osdl.org
To: Christoph Hellwig <hch@infradead.org>
Cc: kernel-janitors@lists.osdl.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--===============00074499819452578109==
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 15, 2005 at 10:39:59AM +0000, Christoph Hellwig wrote:
> > -	return readb(host->base + (reg^bE));
> > +	return readb((volatile void __iomem *)(host->base + (reg^bE)));
> 
> Again, no.  Stop casting to void __iomem pointers, please don't submit
> a patch like this one again ever.

Actually, for 53c700, I think this *is* the right fix.  Unless we want to
move it away from using host->base (which is marked as "legacy crap", so
maybe we do).  I guess pushing it into hostdata is the preferred way?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain

--===============00074499819452578109==
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

_______________________________________________
Kernel-janitors mailing list
Kernel-janitors@lists.osdl.org
http://lists.osdl.org/mailman/listinfo/kernel-janitors

--===============00074499819452578109==--
