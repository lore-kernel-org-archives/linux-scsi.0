From: Roland Dreier <roland@kernel.org>
Subject: mpt2sas losing reset events with cable pulls?
Date: Tue, 30 Aug 2011 17:51:08 -0700
Message-ID: <1314751868-1112-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog112.obsmtp.com ([74.125.245.92]:54872 "HELO
	na3sys010aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754263Ab1HaAvN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2011 20:51:13 -0400
Received: by mail-iy0-f175.google.com with SMTP id z35so215319iag.6
        for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2011 17:51:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@lsi.com>, Eric Moore <eric.moore@lsi.com>
Cc: eric@purestorage.com, linux-scsi@vger.kernel.org

Hi!

We have a system with mpt2sas driver from the upstream kernel --

    #define MPT2SAS_DRIVER_VERSION              "09.100.00.00"

and hardware:

    mpt2sas1: LSISAS2008: FWVersion(09.00.00.00), ChipRevision(0x03), BiosVersion(07.17.00.00)

We have a SAS JBOD with a bunch of SSDs in it, connected with two wide
SAS ports, running Linux multipathing.  If we pull one of the cables
with IO running, then occasionally (say, 1 in 100 cable pulls) some of
the IO gets "stuck" -- we continually hit

	else if (sas_device_priv_data->block || sas_target_priv_data->tm_busy)
		return SCSI_MLQUEUE_DEVICE_BUSY;

in the mpt2sas _scsih_qcmd() function, where tm_busy never gets
cleared.  We added some debugging to _scsih_sas_device_status_change_event()
and we found that when things go wrong, we get an event of type
MPI2_EVENT_SAS_DEV_STAT_RC_INTERNAL_DEVICE_RESET for each one of the
SSDs (which sets tm_busy for each target), but then
MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET never comes for one
of the targets (so tm_busy is never cleared).

In other words, we get the reset event for handle 0x24, 0x25, ...,
0x3a with all the handles in the range (and hence all the targets)
getting an event; but then in the broken case, the reset complete
event comes for all the handles *except* one (for example 0x39).

This leads to the system getting wedged waiting for a SCSI command
that will never finish, which is not what we're after when one of our
paths to the JBOD goes down (given that we have a second path and are
aiming at fault tolerance here!).

This feels to me like it is probably a firmware race or some other
bug, but perhaps the driver is losing events somehow.  Anyway, how can
we fix this?  Please let me know if there's any further debugging
information I can collect to help make progress on this.

Thanks!
  Roland
