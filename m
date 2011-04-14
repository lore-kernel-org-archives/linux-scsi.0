From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH, RFC] isci: remove scic_controller state handlers
Date: Wed, 13 Apr 2011 18:17:25 -0700
Message-ID: <BANLkTi=aDVT-OLdmXzu2E4hB5Tek8AcTaA@mail.gmail.com>
References: <20110402121520.GB30913@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56321 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab1DNBR1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2011 21:17:27 -0400
Received: by fxm17 with SMTP id 17so846103fxm.19
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2011 18:17:26 -0700 (PDT)
In-Reply-To: <20110402121520.GB30913@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Dave Jiang <dave.jiang@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>

On Sat, Apr 2, 2011 at 5:15 AM, Christoph Hellwig <hch@infradead.org> w=
rote:
> Remove the state handler indirections for the scic_controller, and re=
place
> them with procedural calls that check for the correct state first.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
[..]
> - =A0 =A0 =A0 scic_sds_controller_start_request_handler_t start_io;
> + =A0 =A0 =A0 enum sci_status status;
>
> - =A0 =A0 =A0 state =3D scic->state_machine.current_state_id;
> - =A0 =A0 =A0 start_io =3D scic_sds_controller_state_handler_table[st=
ate].start_io;
> + =A0 =A0 =A0 if (scic->state_machine.current_state_id !=3D
> + =A0 =A0 =A0 =A0 =A0 SCI_BASE_CONTROLLER_STATE_READY) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_warn(scic_to_dev(scic), "invalid st=
ate to start I/O");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return SCI_FAILURE_INVALID_STATE;
> + =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 return start_io(scic,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct sci_base_remote=
_device *) remote_device,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 request, io_tag);
> + =A0 =A0 =A0 status =3D scic_sds_remote_device_start_io(scic, rdev, =
req);

Nice, we casted to a base device only to pass it to a routine that
took a device directly.  Glad that's gone.

Everything else looks ok.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
