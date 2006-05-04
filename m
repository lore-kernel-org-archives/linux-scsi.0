From: Thomas Horsten <thomas@horsten.com>
Subject: RE: [PATCH] MegaRAID driver management char device moved to misc
Date: Thu, 4 May 2006 14:37:30 +0100 (BST)
Message-ID: <Pine.LNX.4.40.0605041434430.15259-100000@jehova.dsm.dk>
References: <890BF3111FB9484E9526987D912B261901BD2B@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750894AbWEDNhj@vger.kernel.org>
In-Reply-To: <890BF3111FB9484E9526987D912B261901BD2B@NAMAIL3.ad.lsil.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: linux-kernel@vger.kernel.org, "Kolli, Neela" <Neela.Kolli@engenio.co>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 4 May 2006, Ju, Seokmann wrote:

> Hi,
>
> For following reason, I cannot accept/approve this patch.
> I'll update further as I get clear.
>
> Thank you,
>
> > So it now uses a misc device which I named "megadev0" (the
> > name that megarc
> > expects), and has a dynamic minor (previoulsy a dynamic major
> > was used).
> The driver can not change device node name for backward compatibility.
> I'm checking with application team inside for further clarification and update here.

That is an invalid reason: There was no hardcoded device node previously
(it was using a dynamically assigned major).

The only tool I know which uses this device is "megarc" from LSI Logic.
This tool uses the char device /dev/megaraid0, which will be created
correctly when using my patch and udev (the recommended setup for Linux
2.6 systems). I have tested this and it works.

User-level applications should not rely on hardcoded device numbers in any
case, but should use the correct device from /dev or search for the device
they need in sysfs.

Thomas
