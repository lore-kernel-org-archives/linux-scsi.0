From: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: UASP: updates and merges
Date: Thu, 13 Jan 2011 02:45:24 -0800 (PST)
Message-ID: <419275.23415.qm@web31813.mail.mud.yahoo.com>
Reply-To: ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The UASP driver allows you to connect to UAS devices and use them
as SCSI devices.

I've merged latest master (f87813) and resolved a conflict in drivers/scsi/sd.c by adding back the truncation of the mode sense data.

The UASP driver saw the following update:

    [USB] UASP: factor out GFP flags and make them GFP_ATOMIC
    
    Factor out the GFP flags and make them atomic:
    1) The SCSI subsystem uses GFP_ATOMIC, e.g. before
    calling the host's slave_alloc callback (at the
    time of this commit).
    2) As we are a storage driver doing I/O, we should
    use the lowest denominator (highest priority)
    allocation, and of course we shouldn't sleep, thus
    use GFP_ATOMIC.

The branch can be found here (off of master):
https://github.com/ltuikov/linux-2.6

Original posting of the UASP driver can be found here:
http://marc.info/?l=linux-usb&m=129165511732388&w=2

   Luben

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
