From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: [ofa-general] Re: sg_reset can trigger a NULL pointer dereference in
	the SRP initiator
Date: Thu, 6 Aug 2009 17:38:18 +0200
Message-ID: <e2e108260908060838u34b97ab4n6e2007dbb6937ff5@mail.gmail.com>
References: <e2e108260908060039x7718577yf932d8a9188fe0cb@mail.gmail.com>
	<4A7A949B.60408@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <4A7A949B.60408@panasas.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <rdreier@cisco.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, OpenIB <general@lists.openfabrics.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 6, 2009 at 10:30 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> [Just out of memory, I've not inspected the code for a long time]
>
> It looks like an srp_request was never allocated for the reset
> command. (since it never went through .queuecommand)
>
> static int srp_find_req(struct srp_target_port *target,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct scsi_cmnd *scmnd,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct srp_request **req)
> {
> =A0 =A0 =A0 =A0if (scmnd->host_scribble =3D=3D (void *) -1L)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -1;
>
> =A0 =A0 =A0 =A0*req =3D &target->req_ring[(long) scmnd->host_scribble];
>
> =A0 =A0 =A0 =A0return 0;
> }
>
> Specifically scmnd->host_scribble can just be Zero.
> When queues are active that does not matter and a device is found
> since the reset does not really need the scsi_cmnd. But in above
> scenario the queues were never used and the array entry is empty.

Hello Boaz,

Thanks for the info. Do you know by heart which SCSI drivers process
the SG_SCSI_RESET ioctl correctly and that could be used as an example
for fixing the SRP initiator ?

Bart.
