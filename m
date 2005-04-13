From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [KJ] Re: [PATCH] scsi/a100u2w: Remove custom msecs_to_jiffies and
	jiffies_to_msecs macros
Date: Wed, 13 Apr 2005 10:00:58 -0500
Message-ID: <1113404459.4933.8.camel@mulgrave>
References: <20050413121104.GA9419@argon.tklauser.home>
	<20050413144308.GA9616@infradead.org>
	<20050413145100.GA9958@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============57067332591273967=="
Return-path: <kernel-janitors-bounces@lists.osdl.org>
In-Reply-To: <20050413145100.GA9958@infradead.org>
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
Cc: kernel-janitors@lists.osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--===============57067332591273967==
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2005-04-13 at 15:51 +0100, Christoph Hellwig wrote:
> I actually meant mdelay, but as mentioned in the other followup that might
> need some more research.

Actually, several of the waits look as though they have user context and
so could sleep:

waitChipReady
waitFWReady
waitSCSIRSTdone

These I think are also user context: the aborts and nvram functions all
seem to be user context

waitHDOoff
waitHDIoff

So could someone with a board try the theory (that msleep will work)?

Thanks,

James



--===============57067332591273967==
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

_______________________________________________
Kernel-janitors mailing list
Kernel-janitors@lists.osdl.org
http://lists.osdl.org/mailman/listinfo/kernel-janitors

--===============57067332591273967==--
