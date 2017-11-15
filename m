From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko-WRw03QTAyf3sq35pWSNszA@public.gmane.org>
Subject: Re: Seagate External SMR drive USB resets (was: Re: [PATCH] uas:
 Add US_FL_NO_ATA_1X quirk for one more Seagate device)
Date: Wed, 15 Nov 2017 16:49:02 -0500
Message-ID: <20171115164902.00d1330d@Vantage.cJ>
References: <20171110151344.10563-1-hdegoede@redhat.com>
        <20171112164234.48b5185c@Vantage.cJ>
        <46d6dde9-e811-9655-96db-a046de521782@246060.ru>
        <20171113011438.458369bf@Vantage.cJ>
        <3d276729-63f7-9727-4a22-55849712439c@redhat.com>
        <20171113123814.4e70a498@Vantage.cJ>
        <20171115164314.74ce972f@Vantage.cJ>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171115164314.74ce972f-WI5o+PA4G9BYumZHjSPV5A@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens <jens-bugzilla.kernel.org-pLZ6rgtf4/bvLhUCWVjhBQ@public.gmane.org>, Andrey Astafyev <1@246060.ru>, Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

(Adding Tejun Heo who was assigned on still-open bugzilla #93581 which
is about SATA but seems terribly related.)

On Wed, 15 Nov 2017 16:43:14 -0500
J=C3=A9r=C3=B4me Carretero <cJ-ko-WRw03QTAyf3sq35pWSNszA@public.gmane.org> wrote:

> Hi Hans,
>=20
>=20
> Tests are currently undergoing with drives operating in plain USB mass
> storage class. In a first time, I'm filling drives with data
> (uncontrolled corpus, just TBs that I have on hand). It looks like the
> drives with most usage history are the ones that drop most often.
>=20
> kernel: usb 3-4.1.1: reset SuperSpeed USB device number 6 using
> xhci_hcd kernel: usb 3-4.2.1: reset SuperSpeed USB device number 7
> using xhci_hcd kernel: usb 3-4.3.1.1: reset SuperSpeed USB device
> number 13 using xhci_hcd kernel: usb 3-4.3.2.1: reset SuperSpeed USB
> device number 14 using xhci_hcd kernel: usb 3-4.4: reset SuperSpeed
> USB device number 8 using xhci_hcd kernel: usb 6-4.3.2.1: reset
> SuperSpeed USB device number 8 using xhci_hcd kernel: usb 6-4.3.3.1:
> reset SuperSpeed USB device number 9 using xhci_hcd kernel: usb
> 6-4.4.1: reset SuperSpeed USB device number 6 using xhci_hcd
>=20
> Will provide some more interesting/visual data later.
>=20
>=20
> I'm surprised that the message "reset SuperSpeed USB device ..." is
> displayed without prior information about why.
> Someone with more background could give hints?
>=20
>=20
> I took a look at the USB MSC code and have few questions /
> observations:
>=20
> - It looks like (haven't tested it yet) the CONFIG_DYNAMIC_DEBUG isn't
>   used with the USB mass storage debugging infrastructure, please
>   confirm? If unused, are we interested to have a patch that would go
>   back to regular pr_debug() that can work with dynamic debugging?
>=20
>   Because with several of these drives / lots of activity / occasional
>   issues, it looks like it will be hard to catch (yes I can use
> usbmon).
>=20
> - It looks like there is no configurable timeout for USB MSC requests.
>   Perhaps the device is not responding in time and this is why it's
>   reset?
>=20
>=20
> Best regards,
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
