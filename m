From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH] scsi: ufs: Enable bInitPowerMode of sleep
Date: Tue, 4 Sep 2018 10:01:05 -0700
Message-ID: <CAE=gft7zk-wkKEqFAF+O-HQRGRhD_pgiS0d_HraGFyK8Ac78bQ@mail.gmail.com>
References: <20180810235010.6004-1-evgreen@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180810235010.6004-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, adrian.hunter@intel.com, Stanislav.Nijnikov@wdc.com
Cc: Gwendal Grignou <gwendal@chromium.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 10, 2018 at 4:50 PM Evan Green <evgreen@chromium.org> wrote:
>
> UFS devices can be provisioned to have an initial power mode of either
> active or sleep. If the initial power mode is sleep, then the host
> controller driver must send a START STOP UNIT to the device in order
> to wake it up. Unfortunately, the device will refuse to complete other
> common low level operations, such as reading descriptors and attributes.
> The Linux driver currently fails to enumerate devices that start in
> sleep mode, because it fails to read the device descriptor from the
> unconscious device.
>
> The way the UFS controller driver is structured, this presents a bit of
> a Catch-22. In order to perform low-level enumeration of the device, the
> driver needs to send a SCSI command. But SCSI needs low-level enumeration
> of the device to be complete before full enumeration can occur.
>
> This change adds a method for sending low-level SCSI commands, modeled
> after (and reusing much of) the mechanism for sending device management
> commands. With this primitive, ufshcd_probe_hba can execute REQUEST SENSE
> to clear the Unit Attention, and then a START STOP UNIT in order to bring
> the device out of sleep mode. Only after this is done can the rest of
> enumeration, such as reading the device descriptor and geometry descriptor,
> be done.
>
> Signed-off-by: Evan Green <evgreen@chromium.org>

A very gentle bump, did anyone get a chance to take a look at this?
Currently Linux can't enumerate UFS devices that start in Sleep mode.
