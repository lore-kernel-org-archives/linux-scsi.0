From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: usb hdd problems with 2.6.27.2
Date: Mon, 27 Oct 2008 16:36:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0810271625420.2190-100000@iolanthe.rowland.org>
References: <20081027165306.GA3875@bit.office.eurotux.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081027165306.GA3875-oEplIgxCSygGFt9iVWuREaMaJEuR8uiQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Luciano Rocha <luciano-YWehAnL2kLNBDgjK7y7TUQ@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Linux-Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 27 Oct 2008, Luciano Rocha wrote:

> On Mon, Oct 27, 2008 at 11:38:13AM -0400, Alan Stern wrote:
> > On Mon, 27 Oct 2008, Luciano Rocha wrote:
> > 
> > > Hm, where in the code can I change it to return less that what it thinks
> > > is the last sector?
> > 
> > I can write a patch to do that for you.  However I'm more interested in 
> > solving the "infinite-retry" problem first.

Here's the promised patch.

Alan Stern



Index: usb-2.6/drivers/usb/storage/unusual_devs.h
===================================================================
--- usb-2.6.orig/drivers/usb/storage/unusual_devs.h
+++ usb-2.6/drivers/usb/storage/unusual_devs.h
@@ -1251,6 +1251,13 @@ UNUSUAL_DEV( 0x0839, 0x000a, 0x0001, 0x0
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_INQUIRY),
 
+/* Reported by Luciano Rocha <luciano-YWehAnL2kLNBDgjK7y7TUQ@public.gmane.org> */
+UNUSUAL_DEV( 0x0840, 0x0082, 0x0001, 0x0001,
+		"Argosy",
+		"Storage",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY),
+
 /* Entry and supporting patch by Theodore Kilgore <kilgota-7KF8pGZKO2M3uPMLIKxrzw@public.gmane.org>.
  * Flag will support Bulk devices which use a standards-violating 32-byte
  * Command Block Wrapper. Here, the "DC2MEGA" cameras (several brands) with

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
