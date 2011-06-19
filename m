From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/srp: Fix SCSI scanning
Date: Sun, 19 Jun 2011 20:03:17 +0200
Message-ID: <BANLkTi=5nBDB-SGd0U0UZDgR4gKBDqaj0w@mail.gmail.com>
References: <201106191348.24122.bvanassche@acm.org> <1308504469.14467.5.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1308504469.14467.5.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jun 19, 2011 at 7:27 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> On Sun, 2011-06-19 at 13:48 +0200, Bart Van Assche wrote:
>> Avoid that SCSI scanning triggers creation of targets with non-zero
>> channel or non-zero id.
>
> Good catch, Bart. How did you find this?
>
> I would like to have a little more meat in the description. What real
> problem are we avoiding -- what happens when we get non-zero id/channel?
>
> Based on a quick look at the code -- I don't have ready access to a test
> system today -- I'm guessing that we create duplicate devices as a
> result of a manual scan?

Entirely correct. Some SRP target implementations allow to add and
remove LUNs after an SRP initiator has logged in. In order to update
the initiator a SCSI scan has to be initiated. Invoking the
rescan-scsi-bus.sh script on an initiator learned me that many
unwanted duplicate SCSI devices were created on the initiator.

Regarding the implementation: a SCSI scan is initiated by writing
directly or indirectly to /sys/class/scsi_host/host<number>/scan.
If the transport associated with the involved host provides a custom
scanning method, that method will be invoked. Otherwise
scsi_scan_host_selected() will be invoked. Since the SRP transport
does not provide a custom scanning method, for SRP the latter is
invoked. It is that functin that creates duplicate SCSI device nodes
if not prevented by target_alloc. Since which C:I:L values are valid
depends on the LUN addressing method used by the initiator I opted to
implement the filtering in the initiator driver instead of the
transport. As you might have noticed, the filter proposed for the
ibmvscsi driver differs slightly from the filter for the ib_srp
driver. That is because the ibmvscsi and the ib_srp drivers use
different LUN  addressing methods (see also paragraph 4.7, Logical
Unit Number (LUN) in the T10 SCSI Architecture Model standard).

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
