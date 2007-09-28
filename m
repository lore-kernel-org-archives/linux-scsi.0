From: Oliver Neukum <oliver@neukum.org>
Subject: Re: question on flushing buffers and spinning
	down disk
Date: Fri, 28 Sep 2007 23:47:16 +0200
Message-ID: <200709282347.17184.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0709281705180.7142-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0709281705180.7142-100000@iolanthe.rowland.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Am Freitag 28 September 2007 schrieb Alan Stern:
> On Fri, 28 Sep 2007, Oliver Neukum wrote:
> =

> > Am Donnerstag 27 September 2007 schrieb Alan Stern:
> > > Have you thought about how autoresume would fit into this picture? =
=A0I
> > > don't think you can rely on usb-storage telling the SCSI core to resu=
me
> > > devices when it gets handed a command, because the commands to spin-up
> > > the drives would have to be transmitted first. =A0(The sample patch y=
ou
> =

> I had another look at your patch. =A0It calls scsi_device_quiesce(), =

> which causes all normal requests to be deferred. =A0Hence under normal =

> operation the device would never autoresume -- user requests would be =

> deferred and never sent to usb-storage.

Unless I am very mistaken, further down in storage_suspend, I call

+	/* In case of autosuspend device must be unblocked again */
+	if (us->pusb_dev->auto_pm) {
+err_unblock:
+		shost_for_each_device(sdev, host) {
+			if (sdev =3D=3D sdev2) {
+				scsi_device_put(sdev);
+				break;
+			}
+			scsi_device_resume(sdev);

which again allows normal io, so the autoresume is triggered.
It may deadlock, you are right about that, but it is definitely triggered.
I verified that experimentally.

	Regards
		Oliver


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
