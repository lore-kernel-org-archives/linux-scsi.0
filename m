From: Roland Dreier <roland@kernel.org>
Subject: Re: mpt2sas losing reset events with cable pulls?
Date: Tue, 30 Aug 2011 22:41:25 -0700
Message-ID: <1314769285-13105-1-git-send-email-roland@kernel.org>
References: <CADOQvuP=D3HLSnYNhtiTWC375YwzuXrnGaG=UdS0r8vmWm-A+Q@mail.gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog114.obsmtp.com ([74.125.245.96]:50642 "HELO
	na3sys010aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752758Ab1HaFld (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Aug 2011 01:41:33 -0400
Received: by mail-iy0-f181.google.com with SMTP id z21so465079iab.26
        for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2011 22:41:32 -0700 (PDT)
In-Reply-To: <CADOQvuP=D3HLSnYNhtiTWC375YwzuXrnGaG=UdS0r8vmWm-A+Q@mail.gmail.com>
References: <1314751868-1112-1-git-send-email-roland@kernel.org> <4E5D9F4A.80009@interlog.com> <CAL1RGDU9QtuXGhMQN_cT6+RPh0NTZexYwE8HK1fpw5vuX_FLOw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, eric@purestorage.com, Kashyap Desai <kashyap.desai@lsi.com>, Eric Moore <eric.moore@lsi.com>

>> Most LSI HBA's based on the LSISAS2008 chip are now at
>> firmware version 10.00 . Perhaps you could retest with
>> that firmware.

Just for grins, I updated a test system to 10.00 and retested, and was
able to reproduce the issue with:

    mpt2sas1: LSISAS2008: FWVersion(10.00.02.00), ChipRevision(0x03), BiosVersion(07.17.00.00)

I added the code below to the end of _scsih_sas_device_status_change_event():

        printk(KERN_ERR "%s: %s handle 0x%04x sas address 0x%016llx dev %p priv %p\n", __func__,
               event_data->ReasonCode == MPI2_EVENT_SAS_DEV_STAT_RC_CMP_INTERNAL_DEV_RESET ?
               "internal device reset complete" : "internal device reset",
               le16_to_cpu(event_data->DevHandle), (unsigned long long)le64_to_cpu(event_data->SASAddress),
               sas_device, target_priv_data);

and when I hit the issue, I got the output below -- the thing to
notice is that we get "internal device reset" events for every handle
in the range 0x24 ... 0x3a inclusive, but the "internal device reset
complete" event for handle 0x2b never appears in this case.

So if this is a firmware bug, it is still present at least in the
10.00 firmware I got from the LSI web site...

This reproduction took about 50 loops of a script that turns off and
on the links between the HBA and the JBOD every 15 seconds, so it's
not too hard to hit (you can see from the kernel timestamps that the
system was up less than half an hour total).  If there's any other
debug data to collect or patches to try, I'm happy to do so.

 - R.

    [ 1319.730954] _scsih_sas_device_status_change_event: internal device reset handle 0x0024 sas address 0x500605ba004afb49 dev ffff880619c9c880 priv ffff880615397800
    [ 1319.731019] _scsih_sas_device_status_change_event: internal device reset handle 0x0025 sas address 0x500605ba004afe21 dev ffff880616a8f280 priv ffff880615164c00
    [ 1319.731026] _scsih_sas_device_status_change_event: internal device reset handle 0x0026 sas address 0x500605ba002e1189 dev ffff88061ad03400 priv ffff8806153f0c00
    [ 1319.731034] _scsih_sas_device_status_change_event: internal device reset handle 0x0027 sas address 0x500605ba002e0ea9 dev ffff880614e84100 priv ffff88061516ec00
    [ 1319.731041] _scsih_sas_device_status_change_event: internal device reset handle 0x0028 sas address 0x500605ba004af915 dev ffff88061ace4d80 priv ffff8806138c1800
    [ 1319.731048] _scsih_sas_device_status_change_event: internal device reset handle 0x0029 sas address 0x500605ba002e14d5 dev ffff880619c8aa00 priv ffff880614efec00
    [ 1319.731055] _scsih_sas_device_status_change_event: internal device reset handle 0x002a sas address 0x500605ba002e1201 dev ffff880619c8a200 priv ffff8806138c5c00
    [ 1319.731064] _scsih_sas_device_status_change_event: internal device reset handle 0x002b sas address 0x500605ba002e1049 dev ffff880619c8a800 priv ffff880613d2cc00
    [ 1319.731073] _scsih_sas_device_status_change_event: internal device reset handle 0x002c sas address 0x500605ba002e1615 dev ffff880616bd1e80 priv ffff8806147b4c00
    [ 1319.731082] _scsih_sas_device_status_change_event: internal device reset handle 0x002d sas address 0x500605ba002e1519 dev ffff880616bd1f00 priv ffff880614cdd800
    [ 1319.731088] _scsih_sas_device_status_change_event: internal device reset handle 0x002e sas address 0x500605ba002e15ed dev ffff880613598f80 priv ffff88061a5e6400
    [ 1319.731096] _scsih_sas_device_status_change_event: internal device reset handle 0x002f sas address 0x500605ba002e1371 dev ffff880616bd1280 priv ffff8806137b4800
    [ 1319.731102] _scsih_sas_device_status_change_event: internal device reset handle 0x0030 sas address 0x500605ba002e0f21 dev ffff88061b3f5680 priv ffff880613568800
    [ 1319.731106] _scsih_sas_device_status_change_event: internal device reset handle 0x0031 sas address 0x500605ba002e0ec1 dev ffff880613598980 priv ffff880616b9c400
    [ 1319.731109] _scsih_sas_device_status_change_event: internal device reset handle 0x0032 sas address 0x500605ba004afbd5 dev ffff88061ac07580 priv ffff880619e84400
    [ 1319.731116] _scsih_sas_device_status_change_event: internal device reset handle 0x0033 sas address 0x500605ba002e1129 dev ffff8806169dd080 priv ffff880613da7000
    [ 1319.731119] _scsih_sas_device_status_change_event: internal device reset handle 0x0034 sas address 0x500605ba002e1051 dev ffff8806169ddf80 priv ffff880619e86800
    [ 1319.731124] _scsih_sas_device_status_change_event: internal device reset handle 0x0035 sas address 0x500605ba002e1339 dev ffff8806151a0c00 priv ffff8806151fc800
    [ 1319.731127] _scsih_sas_device_status_change_event: internal device reset handle 0x0036 sas address 0x500605ba002e1551 dev ffff880614e38080 priv ffff880616b99000
    [ 1319.731131] _scsih_sas_device_status_change_event: internal device reset handle 0x0037 sas address 0x500605ba002e118d dev ffff88061b09c400 priv ffff880619e83c00
    [ 1319.731136] _scsih_sas_device_status_change_event: internal device reset handle 0x0038 sas address 0x500605ba002e1285 dev ffff88061b3f5980 priv ffff880613da1c00
    [ 1319.731168] _scsih_sas_device_status_change_event: internal device reset handle 0x0039 sas address 0x500605ba002e1429 dev ffff88061ac07d80 priv ffff880614630800
    [ 1319.731173] _scsih_sas_device_status_change_event: internal device reset handle 0x003a sas address 0x50050cc10ac3dc7e dev ffff880619c96080 priv ffff8806148e6800
    [ 1319.733351] _scsih_sas_device_status_change_event: internal device reset complete handle 0x0024 sas address 0x500605ba004afb49 dev ffff880619c9c880 priv ffff880615397800
    [ 1319.733360] _scsih_sas_device_status_change_event: internal device reset complete handle 0x0025 sas address 0x500605ba004afe21 dev ffff880616a8f280 priv ffff880615164c00
    [ 1319.733363] _scsih_sas_device_status_change_event: internal device reset complete handle 0x0026 sas address 0x500605ba002e1189 dev ffff88061ad03400 priv ffff8806153f0c00
    [ 1319.733366] _scsih_sas_device_status_change_event: internal device reset complete handle 0x0027 sas address 0x500605ba002e0ea9 dev ffff880614e84100 priv ffff88061516ec00
    [ 1319.733370] _scsih_sas_device_status_change_event: internal device reset complete handle 0x0028 sas address 0x500605ba004af915 dev ffff88061ace4d80 priv ffff8806138c1800
    [ 1319.733373] _scsih_sas_device_status_change_event: internal device reset complete handle 0x0029 sas address 0x500605ba002e14d5 dev ffff880619c8aa00 priv ffff880614efec00
    [ 1319.733378] _scsih_sas_device_status_change_event: internal device reset complete handle 0x002a sas address 0x500605ba002e1201 dev ffff880619c8a200 priv ffff8806138c5c00
    [ 1319.733383] _scsih_sas_device_status_change_event: internal device reset complete handle 0x002c sas address 0x500605ba002e1615 dev ffff880616bd1e80 priv ffff8806147b4c00
    [ 1319.733386] _scsih_sas_device_status_change_event: internal device reset complete handle 0x002d sas address 0x500605ba002e1519 dev ffff880616bd1f00 priv ffff880614cdd800
    [ 1319.733389] _scsih_sas_device_status_change_event: internal device reset complete handle 0x002e sas address 0x500605ba002e15ed dev ffff880613598f80 priv ffff88061a5e6400
    [ 1319.733392] _scsih_sas_device_status_change_event: internal device reset complete handle 0x002f sas address 0x500605ba002e1371 dev ffff880616bd1280 priv ffff8806137b4800
    [ 1319.733395] _scsih_sas_device_status_change_event: internal device reset complete handle 0x0030 sas address 0x500605ba002e0f21 dev ffff88061b3f5680 priv ffff880613568800
    [ 1319.733400] _scsih_sas_device_status_change_event: internal device reset complete handle 0x0031 sas address 0x500605ba002e0ec1 dev ffff880613598980 priv ffff880616b9c400
    [ 1319.733406] _scsih_sas_device_status_change_event: internal device reset complete handle 0x0032 sas address 0x500605ba004afbd5 dev ffff88061ac07580 priv ffff880619e84400
    [ 1319.733479] _scsih_sas_device_status_change_event: internal device reset complete handle 0x0033 sas address 0x500605ba002e1129 dev ffff8806169dd080 priv ffff880613da7000
    [ 1319.733486] _scsih_sas_device_status_change_event: internal device reset complete handle 0x0034 sas address 0x500605ba002e1051 dev ffff8806169ddf80 priv ffff880619e86800
    [ 1319.733490] _scsih_sas_device_status_change_event: internal device reset complete handle 0x0035 sas address 0x500605ba002e1339 dev ffff8806151a0c00 priv ffff8806151fc800
    [ 1319.733495] _scsih_sas_device_status_change_event: internal device reset complete handle 0x0036 sas address 0x500605ba002e1551 dev ffff880614e38080 priv ffff880616b99000
    [ 1319.733498] _scsih_sas_device_status_change_event: internal device reset complete handle 0x0037 sas address 0x500605ba002e118d dev ffff88061b09c400 priv ffff880619e83c00
    [ 1319.733501] _scsih_sas_device_status_change_event: internal device reset complete handle 0x0038 sas address 0x500605ba002e1285 dev ffff88061b3f5980 priv ffff880613da1c00
    [ 1319.733508] _scsih_sas_device_status_change_event: internal device reset complete handle 0x0039 sas address 0x500605ba002e1429 dev ffff88061ac07d80 priv ffff880614630800
    [ 1319.733514] _scsih_sas_device_status_change_event: internal device reset complete handle 0x003a sas address 0x50050cc10ac3dc7e dev ffff880619c96080 priv ffff8806148e6800
