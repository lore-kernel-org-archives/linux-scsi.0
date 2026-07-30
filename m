Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128AD39150A
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 19:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785438319; cv=pass; b=LB1EqMxJ39niW8ij6pr3FNnRl7AhlPaf6mDbhNMlD19uAAuxL4hdRxbJHfQy0xOGvXOI3aTyin3Ke4Y+0IQH/tts2Last4D2YQ5/AtboeKKkcX8KHu8EzB+fAEbat7Uwm7ulmcgQXlmpVVgdvysU1hYy7TppP0S955cv8LR+Fnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785438319; c=relaxed/simple;
	bh=eFGBeo5M2vVMTKElI8g7E5j0dohkvXYTaUI3ayfq44Y=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=vCuJxc+V8XAXQadNs6H1q+jNajAiNvFD7oiOFI1uRQFSN+cEckdWbsekiGIGMsP+jn9+NdTaelg/MWXiC+EGmsks1v/ZIu/cmd+mY/6DiP8gDzBS1+WdJunUcgPb1xAxLhtRsTFiJn/fMQ5oRFDB1Yrwx2CxZdDAInD4tIxIcA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cT2AWmQF; arc=pass smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cT2AWmQF"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-6aaf3f54dbeso25106eaf.2
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 12:05:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785438316; cv=none;
        d=google.com; s=arc-20260327;
        b=ZCqndV8hXFghfCl9kEzd30/Cz0AmSHXYx7Frc/IXpZCHYISicRUvPIhnW4Xi/wKqh+
         uJc5/oK2qtE2OK0iI2BnSgyGbQ+QGbE+RpTtkKyYkDgA+X3uaHYZMgjuk45s6SOxQeRZ
         4/wRJTKWxEDoiZ7VNH+uc+VWl8ThMC8b8TYgxEL4xojhygWveeb3XZXOHQLjp+uGuqnt
         jd1ztRuz9Yfdu+efnLtpWRZPX0Jc2HONqbnEHCJvtw3NsXQ+gNZt+crvqNz/iPk2rklP
         guzsDQd7VV8U6p02x3HC66nSEPt5Pki/6/rYQHKT23wt6CQg8dC5el/huWY8RVnPP/Tu
         TAcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=zLUFh7EQPPgKFUnL61rEuCvVzIwhZDs8xuSk2qqo2HA=;
        fh=4DxivVpieTU2rsW8prpAmnuUhukoEC7l7zFMkMa8QfI=;
        b=iBxn1SzUeYzrAAMjuvUZNpoj2UJ72gjz8GPStoeSN/IV1flwR1v3VJBvzOfFXcLHiI
         xrFMO8cEVLECWZnz+bEyPd+FMx8zghpuKhD9BzaMb/zRozAlEy81MVUi7J0g/Q/Pwf6u
         S6Ceg5aRwAr/5jgVW4iWUGY2BJE89iCoWxt4FoGHIvls/W292K+FF9wN4HW+UjWmK9pL
         /ieK6cjX4PQyqPiNNf5N/UCK/XFtJef+GS4clXemKWRJX6xd7lKKS3x8/B64OPuimMJb
         yj0wcol4B9l79upUKAd6AwTmeeYjT6YGSGFTkYjJeC6ZF59ZUTMSm80ACrMPrdX1qAgy
         iAeQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785438316; x=1786043116; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zLUFh7EQPPgKFUnL61rEuCvVzIwhZDs8xuSk2qqo2HA=;
        b=cT2AWmQF04V+RLDvjgc9Mh6uv0KvQ2yyLaxUvw09+9BWYJeNbY4Cy8WnJ1bXNl3Ouv
         MlfRCjHT3dOutGluSLOIzyp81oGvmiQcgiZk5uLSogkC1vfEyDwaXh65oHc4RrCzLsaX
         vMU9lcyzcwVPt3Ru7Cl1PQbjVdpFLPLDZVo3ULB/7kssSCmUfM6M6xogbHcwVrCwgVK+
         LpRYf1pVcHOFhjuXDuAVm7xyCdu5uGUmyyfsL2bdaghCm+UAVfg/aX0kcUT6CbeWfGMp
         jFZ6DH+S2Fv19oJ48VofcpxBlNZqOioH9zy8FM7kiFXE/gL41V1o398NMSmPlyz2AYIW
         OqfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785438316; x=1786043116;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zLUFh7EQPPgKFUnL61rEuCvVzIwhZDs8xuSk2qqo2HA=;
        b=lTRMQhoAq/k5QThD8eb7+L2whhfnjZw2pHhN9cfIBsClQ/lwa+QVrCFpvWD5yF9Z2B
         GN1lY7qZ6TU7fCTca05N2NRUD6qxRsROm08zQHshhWaBKZnqASLw7qVTw+/vJX8fTnYm
         v7ATnqdZupjEA4ovM4Zhv42ihUMjO1zMJdmIQlZGQOn1PminbZXsw6dAHVaySvr0+P73
         MrjuCk+hq7TYSjKQl4bKr/9L9bzxkvogbTFocdA3aDvHozciBZACDgAoWlkeWtkBpiD9
         ScCZ+wvlVNdKHJjSme/2IkwOyrsExHw9gWnsIHJaJYoIFpGdOkdY4Bko2AkaWDEsDIXF
         GwQQ==
X-Forwarded-Encrypted: i=1; AHgh+RoZiEgJbz7DPix9C0pmBSw8yxo07RsI7qrOjyrSVC1yVHNT57FoCSHLMOZMjIi3absLdkv0Ool0jszA@vger.kernel.org
X-Gm-Message-State: AOJu0Ywd8qrL/vnMq1T6iIyDdsfK0Wil5VhesH1paJlP9G3ChV2A0VTi
	Dc82/HFi0VEvdJXjCrmLJWaD70oXDUHFFd2xXJrcaoNkDaV5vHIEo/preOt91mYsxpuxcJR56rR
	RmuTQinokaxmDijlwmWOf8BBgAFwKc60=
X-Gm-Gg: AR+sD11Vu2+XLmKQg9gDv4UIKVVv982qpQXwbASLewmS9SGhg6Vaa29+7ZTDgM5W9Mi
	Vo0w+Y37UNTS4/p0frF3zMYSM7TcZWEKa8eeC01hxVVZZdieRZ4SeK7yscESIhJOUEsNwu3hqUC
	dZXN3mzzYrj7Rc8pvjMo0kYb94LpYdqkJdRHHM1wGZBuLcjIHQgR7HS/xnLdQaE6Je+B2D5q/WX
	ovTNxfdVypbJ7zJ/MSCAi5P114CGnQPx2/lTRyZ0lWsbzXlrv4UIwYy9mT613aWrrfVAaskLFHH
	eCunTvIlo+M9Aq6cmmPGIU3uncaIX5FMEcXuV98Ax+uocw==
X-Received: by 2002:a05:6820:809:b0:6ac:b5df:ec84 with SMTP id
 006d021491bc7-6acbc114e96mr2329830eaf.71.1785438315748; Thu, 30 Jul 2026
 12:05:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?0JjQu9GM0Y8g0KXQvtC80Y/QutC+0LI=?= <khomyakovilya@gmail.com>
Date: Thu, 30 Jul 2026 22:05:04 +0300
X-Gm-Features: AUfX_mwLzVlOULCBZpVHvz_aZSNCd2ykvQvK4cJH4zmtg9y0FtsVjdAqJCZqCuA
Message-ID: <CABrBgxezQ=e0EOZ8L908wQbmKfJhgtL8CRL2c0py36Q1OSza9A@mail.gmail.com>
Subject: [BUG] scsi: mpi3mr: logical SAS link rate is exported as physical negotiated_linkrate
To: mpi3mr-linuxdrv.pdl@broadcom.com
Cc: sathya.prakash@broadcom.com, kashyap.desai@broadcom.com, 
	sumit.saxena@broadcom.com, sreekanth.reddy@broadcom.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000009463620657d8c0dd"

--0000000000009463620657d8c0dd
Content-Type: text/plain; charset="UTF-8"

Hello.

I would like to report an incorrect SAS PHY link-rate value exported by
the mpi3mr driver through the Linux SAS transport class.

Test configuration
------------------

Controller under test:
  Broadcom eHBA 9600-16e
  ASIC: SAS4016 B0
  PCI address: 0000:32:00.0
  Driver: mpi3mr 8.17.1.0.0
  Firmware: 8.17.1.0-00000-00001
  Mode: Perf-IT SAS Only

Reference controller:
  Broadcom 9500
  ASIC: SAS3816 A0
  PCI address: 0000:ca:00.0
  Driver: mpt3sas 57.00.00.00
  Firmware: 38.00.00.00

Both controllers are connected to the same Microchip SXP 42x24G
expander.

Observed result
---------------

For the same local expander PHYs:

PHY    mpt3sas sysfs    mpi3mr sysfs    expander-side EOM
17       22.5 Gbit/s      1.5 Gbit/s       22.5 Gbit/s
18       12.0 Gbit/s      1.5 Gbit/s       12.0 Gbit/s
19       12.0 Gbit/s      1.5 Gbit/s       12.0 Gbit/s
24       22.5 Gbit/s      1.5 Gbit/s       22.5 Gbit/s
25       22.5 Gbit/s      1.5 Gbit/s       22.5 Gbit/s
26       22.5 Gbit/s      1.5 Gbit/s       22.5 Gbit/s
27       22.5 Gbit/s      1.5 Gbit/s       22.5 Gbit/s
28       12.0 Gbit/s      1.5 Gbit/s       12.0 Gbit/s

The value is read from:

  /sys/class/sas_phy/phy-*/negotiated_linkrate

The mpt3sas value agrees with the independent physical-rate
measurement on the expander side.

Source-code analysis
--------------------

The MPI3 negotiated_link_rate byte contains:

  bits 7:4 - logical negotiated rate
  bits 3:0 - physical negotiated rate

mpi3mr populates sas_phy->negotiated_linkrate using:

  MPI3_SAS_NEG_LINK_RATE_LOGICAL_MASK
  MPI3_SAS_NEG_LINK_RATE_LOGICAL_SHIFT

mpt3sas populates the equivalent SAS transport field using the
physical low nibble:

  MPI2_SAS_NEG_LINK_RATE_MASK_PHYSICAL

Linux sas_phy->negotiated_linkrate describes a physical PHY, so it
appears that mpi3mr should use the MPI3 physical low nibble in all
initial-discovery, refresh and link-update paths.

Impact
------

The incorrect value causes false 1.5 Gbit/s downshift reports in sysfs,
sasutils, monitoring and hardware-validation software, while the
physical links continue operating at 12 or 22.5 Gbit/s.

Please confirm whether this is a driver defect and whether the physical
low nibble should be used for sas_phy->negotiated_linkrate.

Example with two 9500 and 9600 controllers connected to one expander:
sg_map -x -i
/dev/sg0  8 0 0 0  0  /dev/sda  ATA       Samsung SSD 860   4B6Q
/dev/sg1  16 0 0 0  13  Adaptec   Smart Adapter     8.23
/dev/sg2  16 2 0 0  12  Adaptec   1100-8e           8.23
/dev/sg3  15 0 0 0  0  /dev/sdb  SAMSUNG   MZILG3T8HCLS/A07  GXG3
/dev/sg4  15 0 1 0  0  /dev/sdc  HGST      HUH721212AL4204   C3F0
/dev/sg5  15 0 2 0  0  /dev/sdd  HGST      HUH721212AL4204   C3F0
/dev/sg6  15 0 3 0  0  /dev/sde  SAMSUNG   MZILG3T8HCLS/A07  GXG3
/dev/sg7  15 0 4 0  0  /dev/sdf  SAMSUNG   MZILG3T8HCLS/A07  GXG3
/dev/sg8  15 0 5 0  0  /dev/sdg  SAMSUNG   MZILG3T8HCLS/A07  GXG3
/dev/sg9  15 0 6 0  0  /dev/sdh  SAMSUNG   MZILG3T8HCLS/A07  GXG3
/dev/sg10  15 0 7 0  0  /dev/sdi HGST     HUH721212AL4204   C3D0
/dev/sg11  15 0 8 0  13          SXP 42x24G        RevB  (from 9500)
/dev/sg12  0 0 0 0  0  /dev/sdj  SAMSUNG   MZILG3T8HCLS/A07  GXG3
/dev/sg13  0 0 1 0  0  /dev/sdk  HGST      HUH721212AL4204   C3F0
/dev/sg14  0 0 2 0  0  /dev/sdl  HGST      HUH721212AL4204   C3F0
/dev/sg15  0 0 3 0  0  /dev/sdm  SAMSUNG   MZILG3T8HCLS/A07  GXG3
/dev/sg16  0 0 4 0  0  /dev/sdn  SAMSUNG   MZILG3T8HCLS/A07  GXG3
/dev/sg17  0 0 5 0  0  /dev/sdo  SAMSUNG   MZILG3T8HCLS/A07  GXG3
/dev/sg18  0 0 6 0  0  /dev/sdp  SAMSUNG   MZILG3T8HCLS/A07  GXG3
/dev/sg19  0 0 7 0  0  /dev/sdq  HGST      HUH721212AL4204   C3D0
/dev/sg20  0 0 8 0  13           SXP 42x24G        RevB (from 9600)

From 9600-16e:
./microchip_page84_probe_v3.py phys --device /dev/sg20
SXP PM8xxx local PHYs for /dev/sg20
PHY  Link   Negotiated              Invalid         Disp     LossSync
      Reset
------------------------------------------------------------------------------------------
  0  UP     22.5 Gbit                     0            0            3
          0
  1  UP     22.5 Gbit                     0            0            3
          0
  2  UP     22.5 Gbit                     0            0            3
          0
  3  UP     22.5 Gbit                     0            0            3
          0
  4  DOWN   Unknown                0            0            0            0
  5  DOWN   Unknown                0            0            0            0
  6  DOWN   Unknown                0            0            0            0
  7  DOWN   Unknown                0            0            0            0
  8  DOWN   Unknown                0            0            0            0
  9  DOWN   Unknown                0            0            0            0
 10  DOWN   Unknown               0            0            0            0
 11  DOWN   Unknown               0            0            0            0
 12  UP     12.0 Gbit                   827          767       4            0
 13  UP     12.0 Gbit                    22           22         4            0
 14  UP     12.0 Gbit                  1930         1883     5            0
 15  UP     12.0 Gbit                   386          386       5            0
 16  DOWN   Unknown               0            0            0            0
 17  UP     1.5 Gbit                      0            0            0
          0
 18  UP     1.5 Gbit                      0            0            0
          0
 19  UP     1.5 Gbit                      0            0            0
          0
 20  DOWN   Unknown               0            0            0            0
 21  DOWN   Unknown               0            0            0            0
 22  DOWN   Unknown               0            0            0            0
 23  DOWN   Unknown               0            0            0            0
 24  UP     1.5 Gbit                    325          324        1            0
 25  UP     1.5 Gbit                      0            0            0
          0
 26  UP     1.5 Gbit                      0            0            0
          0
 27  UP     1.5 Gbit                      0            0            0
          0
 28  UP     1.5 Gbit                      0            0            0
          0
 29  DOWN   Unknown               0            0            0            0
 30  DOWN   Unknown               0            0            0            0
 31  DOWN   Unknown               0            0            0            0
 32  DOWN   Phy disabled         0            0            0            0
 33  DOWN   Phy disabled         0            0            0            0
 34  DOWN   Phy disabled         0            0            0            0
 35  DOWN   Phy disabled         0            0            0            0
 36  DOWN   Phy disabled         0            0            0            0
 37  DOWN   Phy disabled         0            0            0            0
 38  DOWN   Phy disabled         0            0            0            0
 39  DOWN   Phy disabled         0            0            0            0
 40  DOWN   Phy disabled         0            0            0            0
 41  DOWN   Phy disabled         0            0            0            0
.
From 9500-16e
./microchip_page84_probe_v3.py phys --device /dev/sg11
SXP PM8xxx local PHYs for /dev/sg11
PHY  Link   Negotiated              Invalid         Disp     LossSync
      Reset
------------------------------------------------------------------------------------------
  0  UP     22.5 Gbit                     0            0            3
          0
  1  UP     22.5 Gbit                     0            0            3
          0
  2  UP     22.5 Gbit                     0            0            3
          0
  3  UP     22.5 Gbit                     0            0            3
          0
  4  DOWN   Unknown                0            0            0            0
  5  DOWN   Unknown                0            0            0            0
  6  DOWN   Unknown                0            0            0            0
  7  DOWN   Unknown                0            0            0            0
  8  DOWN   Unknown                0            0            0            0
  9  DOWN   Unknown                0            0            0            0
 10  DOWN   Unknown               0            0            0            0
 11  DOWN   Unknown               0            0            0            0
 12  UP     12.0 Gbit                   827          767       4            0
 13  UP     12.0 Gbit                    22           22         4            0
 14  UP     12.0 Gbit                  1930         1883     5            0
 15  UP     12.0 Gbit                   386          386       5            0
 16  DOWN   Unknown                0            0            0            0
 17  UP     22.5 Gbit                     0            0            0
          0
 18  UP     12.0 Gbit                     0            0            0
          0
 19  UP     12.0 Gbit                     0            0            0
          0
 20  DOWN   Unknown                0            0            0            0
 21  DOWN   Unknown                0            0            0            0
 22  DOWN   Unknown                0            0            0            0
 23  DOWN   Unknown                0            0            0            0
 24  UP     12.0 Gbit                   325          324        1            0
 25  UP     12.0 Gbit                     0            0            0
          0
 26  UP     12.0 Gbit                     0            0            0
          0
 27  UP     12.0 Gbit                     0            0            0
          0
 28  UP     12.0 Gbit                     0            0            0
          0
 29  DOWN   Unknown                0            0            0            0
 30  DOWN   Unknown                0            0            0            0
 31  DOWN   Unknown                0            0            0            0
 32  DOWN   Phy disabled          0            0            0            0
 33  DOWN   Phy disabled          0            0            0            0
 34  DOWN   Phy disabled          0            0            0            0
 35  DOWN   Phy disabled          0            0            0            0
 36  DOWN   Phy disabled          0            0            0            0
 37  DOWN   Phy disabled          0            0            0            0
 38  DOWN   Phy disabled          0            0            0            0
 39  DOWN   Phy disabled          0            0            0            0
 40  DOWN   Phy disabled          0            0            0            0
 41  DOWN   Phy disabled          0            0            0            0


Regards,

Ilya Khomyakov
khomyakovilya@gmail.com

--0000000000009463620657d8c0dd
Content-Type: application/octet-stream; 
	name="0001-scsi-mpi3mr-report-the-physical-SAS-PHY-link-rate.patch"
Content-Disposition: attachment; 
	filename="0001-scsi-mpi3mr-report-the-physical-SAS-PHY-link-rate.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ms7uri9r0>
X-Attachment-Id: f_ms7uri9r0

RnJvbSA1YTIzN2MyMmQzMDMzZjlmM2U4YmUwZmM5Zjk4NGJkMzM3MTRkNzQxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBJbHlhIEtob215YWtvdiBraG9teWFrb3ZpbHlhQGdtYWlsLmNv
bQpEYXRlOiBUaHUsIDMwIEp1bCAyMDI2IDE1OjQwOjQ5ICswMDAwClN1YmplY3Q6IFtQQVRDSCAx
LzJdIHNjc2k6IG1waTNtcjogcmVwb3J0IHRoZSBwaHlzaWNhbCBTQVMgUEhZIGxpbmsgcmF0ZQoK
TVBJMyBwYWNrcyB0aGUgbG9naWNhbCBjb25uZWN0aW9uIHJhdGUgaW50byBiaXRzIDc6NCBhbmQg
dGhlIHBoeXNpY2FsClNlckRlcyByYXRlIGludG8gYml0cyAzOjAgb2YgbmVnb3RpYXRlZF9saW5r
X3JhdGUuICBUaGUgU0FTIHRyYW5zcG9ydApzYXNfcGh5IG9iamVjdCByZXByZXNlbnRzIGEgcGh5
c2ljYWwgUEhZLCBidXQgbXBpM21yIGN1cnJlbnRseSBleHBvcnRzCnRoZSBsb2dpY2FsIGZpZWxk
LgoKVGhpcyBjYW4gZXhwb3NlIDEuNSBHYml0L3MgdGhyb3VnaCBzeXNmcyBmb3IgbGlua3MgcGh5
c2ljYWxseSBydW5uaW5nIGF0CjEyIG9yIDIyLjUgR2JpdC9zLiAgQSBzaWRlLWJ5LXNpZGUgdGVz
dCB0aHJvdWdoIHRoZSBzYW1lIE1pY3JvY2hpcCBTWFAKMjRHIGV4cGFuZGVyIHNob3dlZCBtcHQz
c2FzIHJlcG9ydGluZyB0aGUgcGh5c2ljYWwgcmF0ZSB3aGlsZSBtcGkzbXIKcmVwb3J0ZWQgdGhl
IGxvZ2ljYWwgcmF0ZS4KClVzZSB0aGUgcGh5c2ljYWwgZmllbGQgY29uc2lzdGVudGx5IGluIHRo
ZSBQSFkgYWRkLCByZWZyZXNoLCBsaW5rLXVwZGF0ZQphbmQgdGFyZ2V0LXJlcG9ydGluZyBwYXRo
cy4gIFRoaXMgbWF0Y2hlcyB0aGUgbXB0M3NhcyBtYXBwaW5nIGZvcgpzYXNfcGh5LT5uZWdvdGlh
dGVkX2xpbmtyYXRlLgotLS0KIGRyaXZlcnMvc2NzaS9tcGkzbXIvbXBpM21yX3RyYW5zcG9ydC5j
IHwgNTQgKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAzMSBpbnNl
cnRpb25zKCspLCAyMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvbXBp
M21yL21waTNtcl90cmFuc3BvcnQuYyBiL2RyaXZlcnMvc2NzaS9tcGkzbXIvbXBpM21yX3RyYW5z
cG9ydC5jCmluZGV4IDM5NDYyNDkuLmFlNGY1ZDYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS9t
cGkzbXIvbXBpM21yX3RyYW5zcG9ydC5jCisrKyBiL2RyaXZlcnMvc2NzaS9tcGkzbXIvbXBpM21y
X3RyYW5zcG9ydC5jCkBAIC01ODQsNiArNTg0LDIzIEBAIHN0YXRpYyBlbnVtIHNhc19saW5rcmF0
ZSBtcGkzbXJfY29udmVydF9waHlfbGlua19yYXRlKHU4IGxpbmtfcmF0ZSkKIAlyZXR1cm4gcmM7
CiB9CiAKKy8qKgorICogbXBpM21yX2dldF9zYXNfcGh5X2xpbmtfcmF0ZSAtIGV4dHJhY3QgdGhl
IHBoeXNpY2FsIFNBUyBQSFkgcmF0ZQorICogQG5lZ290aWF0ZWRfbGlua19yYXRlOiBwYWNrZWQg
TVBJMyBsb2dpY2FsIGFuZCBwaHlzaWNhbCBsaW5rLXJhdGUgYnl0ZQorICoKKyAqIE1QSTMgc3Rv
cmVzIHRoZSBsb2dpY2FsIGNvbm5lY3Rpb24gcmF0ZSBpbiBiaXRzIDc6NCBhbmQgdGhlIHBoeXNp
Y2FsCisgKiBTZXJEZXMgcmF0ZSBpbiBiaXRzIDM6MC4gTGludXggc2FzX3BoeSBvYmplY3RzIGRl
c2NyaWJlIHBoeXNpY2FsIFBIWXMsCisgKiBzbyBldmVyeSBTQVMgdHJhbnNwb3J0IG5lZ290aWF0
ZWQtbGluayB1cGRhdGUgbXVzdCB1c2UgdGhlIGxvdyBuaWJibGUuCisgKgorICogUmV0dXJuOiBN
UEkzIHBoeXNpY2FsIG5lZ290aWF0ZWQgbGluay1yYXRlIGNvZGUuCisgKi8KK3N0YXRpYyB1OCBt
cGkzbXJfZ2V0X3Nhc19waHlfbGlua19yYXRlKHU4IG5lZ290aWF0ZWRfbGlua19yYXRlKQorewor
CXJldHVybiAobmVnb3RpYXRlZF9saW5rX3JhdGUgJgorCQlNUEkzX1NBU19ORUdfTElOS19SQVRF
X1BIWVNJQ0FMX01BU0spID4+CisJCU1QSTNfU0FTX05FR19MSU5LX1JBVEVfUEhZU0lDQUxfU0hJ
RlQ7Cit9CisKIC8qKgogICogbXBpM21yX3NldF9pZGVudGlmeSAtIHNldCBpZGVudGlmeSBmb3Ig
cGh5cyBhbmQgZW5kIGRldmljZXMKICAqIEBtcmlvYzogQWRhcHRlciBpbnN0YW5jZSByZWZlcmVu
Y2UKQEAgLTEzNTMsOSArMTM3MCw3IEBAIHN0YXRpYyBpbnQgbXBpM21yX2FkZF9ob3N0X3BoeShz
dHJ1Y3QgbXBpM21yX2lvYyAqbXJpb2MsCiAJCSAgICAmbXJfc2FzX3BoeS0+cmVtb3RlX2lkZW50
aWZ5KTsKIAlwaHktPmlkZW50aWZ5LnBoeV9pZGVudGlmaWVyID0gbXJfc2FzX3BoeS0+cGh5X2lk
OwogCXBoeS0+bmVnb3RpYXRlZF9saW5rcmF0ZSA9IG1waTNtcl9jb252ZXJ0X3BoeV9saW5rX3Jh
dGUoCi0JICAgIChwaHlfcGcwLm5lZ290aWF0ZWRfbGlua19yYXRlICYKLQkgICAgTVBJM19TQVNf
TkVHX0xJTktfUkFURV9MT0dJQ0FMX01BU0spID4+Ci0JICAgIE1QSTNfU0FTX05FR19MSU5LX1JB
VEVfTE9HSUNBTF9TSElGVCk7CisJICAgIG1waTNtcl9nZXRfc2FzX3BoeV9saW5rX3JhdGUocGh5
X3BnMC5uZWdvdGlhdGVkX2xpbmtfcmF0ZSkpOwogCXBoeS0+bWluaW11bV9saW5rcmF0ZV9odyA9
IG1waTNtcl9jb252ZXJ0X3BoeV9saW5rX3JhdGUoCiAJICAgIHBoeV9wZzAuaHdfbGlua19yYXRl
ICYgTVBJM19TQVNfSFdSQVRFX01JTl9SQVRFX01BU0spOwogCXBoeS0+bWF4aW11bV9saW5rcmF0
ZV9odyA9IG1waTNtcl9jb252ZXJ0X3BoeV9saW5rX3JhdGUoCkBAIC0xNDI0LDkgKzE0MzksNyBA
QCBzdGF0aWMgaW50IG1waTNtcl9hZGRfZXhwYW5kZXJfcGh5KHN0cnVjdCBtcGkzbXJfaW9jICpt
cmlvYywKIAkJICAgICZtcl9zYXNfcGh5LT5yZW1vdGVfaWRlbnRpZnkpOwogCXBoeS0+aWRlbnRp
ZnkucGh5X2lkZW50aWZpZXIgPSBtcl9zYXNfcGh5LT5waHlfaWQ7CiAJcGh5LT5uZWdvdGlhdGVk
X2xpbmtyYXRlID0gbXBpM21yX2NvbnZlcnRfcGh5X2xpbmtfcmF0ZSgKLQkgICAgKGV4cGFuZGVy
X3BnMS5uZWdvdGlhdGVkX2xpbmtfcmF0ZSAmCi0JICAgIE1QSTNfU0FTX05FR19MSU5LX1JBVEVf
TE9HSUNBTF9NQVNLKSA+PgotCSAgICBNUEkzX1NBU19ORUdfTElOS19SQVRFX0xPR0lDQUxfU0hJ
RlQpOworCSAgICBtcGkzbXJfZ2V0X3Nhc19waHlfbGlua19yYXRlKGV4cGFuZGVyX3BnMS5uZWdv
dGlhdGVkX2xpbmtfcmF0ZSkpOwogCXBoeS0+bWluaW11bV9saW5rcmF0ZV9odyA9IG1waTNtcl9j
b252ZXJ0X3BoeV9saW5rX3JhdGUoCiAJICAgIGV4cGFuZGVyX3BnMS5od19saW5rX3JhdGUgJiBN
UEkzX1NBU19IV1JBVEVfTUlOX1JBVEVfTUFTSyk7CiAJcGh5LT5tYXhpbXVtX2xpbmtyYXRlX2h3
ID0gbXBpM21yX2NvbnZlcnRfcGh5X2xpbmtfcmF0ZSgKQEAgLTIxOTksMTEgKzIyMTIsOSBAQCBt
cGkzbXJfdHJhbnNwb3J0X3BoeV9zcGVlZChzdHJ1Y3Qgc2FzX3BoeSAqcGh5LCBzdHJ1Y3Qgc2Fz
X3BoeV9saW5rcmF0ZXMgKnJhdGVzKQogCQkgICAgTVBJM19TQVNfUFJBVEVfTUlOX1JBVEVfTUFT
Syk7CiAJCXBoeS0+bWF4aW11bV9saW5rcmF0ZSA9IG1waTNtcl9jb252ZXJ0X3BoeV9saW5rX3Jh
dGUoCiAJCSAgICBwaHlfcGcwLnByb2dyYW1tZWRfbGlua19yYXRlID4+IDQpOwotCQlwaHktPm5l
Z290aWF0ZWRfbGlua3JhdGUgPQotCQkJbXBpM21yX2NvbnZlcnRfcGh5X2xpbmtfcmF0ZSgKLQkJ
CSAgICAocGh5X3BnMC5uZWdvdGlhdGVkX2xpbmtfcmF0ZSAmCi0JCQkgICAgTVBJM19TQVNfTkVH
X0xJTktfUkFURV9MT0dJQ0FMX01BU0spCi0JCQkgICAgPj4gTVBJM19TQVNfTkVHX0xJTktfUkFU
RV9MT0dJQ0FMX1NISUZUKTsKKwkJcGh5LT5uZWdvdGlhdGVkX2xpbmtyYXRlID0gbXBpM21yX2Nv
bnZlcnRfcGh5X2xpbmtfcmF0ZSgKKwkJCW1waTNtcl9nZXRfc2FzX3BoeV9saW5rX3JhdGUoCisJ
CQkgICAgcGh5X3BnMC5uZWdvdGlhdGVkX2xpbmtfcmF0ZSkpOwogCX0KIAogb3V0OgpAQCAtMjgz
Nyw5ICsyODQ4LDggQEAgaW50IG1waTNtcl9leHBhbmRlcl9hZGQoc3RydWN0IG1waTNtcl9pb2Mg
Km1yaW9jLCB1MTYgaGFuZGxlKQogCQkJCSAgICBleHBhbmRlcl9wZzEuYXR0YWNoZWRfZGV2X2hh
bmRsZSk7CiAJCQkJaWYgKHRlbXBfaGFuZGxlICE9IGhhbmRsZSkKIAkJCQkJY29udGludWU7Ci0J
CQkJbGlua19yYXRlID0gKGV4cGFuZGVyX3BnMS5uZWdvdGlhdGVkX2xpbmtfcmF0ZSAmCi0JCQkJ
ICAgIE1QSTNfU0FTX05FR19MSU5LX1JBVEVfTE9HSUNBTF9NQVNLKSA+PgotCQkJCSAgICBNUEkz
X1NBU19ORUdfTElOS19SQVRFX0xPR0lDQUxfU0hJRlQ7CisJCQkJbGlua19yYXRlID0gbXBpM21y
X2dldF9zYXNfcGh5X2xpbmtfcmF0ZSgKKwkJCQkgICAgZXhwYW5kZXJfcGcxLm5lZ290aWF0ZWRf
bGlua19yYXRlKTsKIAkJCQlpZiAobGlua19yYXRlIDwgTVBJM19TQVNfTkVHX0xJTktfUkFURV8x
XzUpCiAJCQkJICAgIGxpbmtfcmF0ZSA9IE1QSTNfU0FTX05FR19MSU5LX1JBVEVfMV81OwogCQkJ
CW1waTNtcl91cGRhdGVfbGlua3MobXJpb2MsIHNhc19hZGRyZXNzX3BhcmVudCwKQEAgLTMwODYs
OCArMzA5Niw4IEBAIHZvaWQgbXBpM21yX3Nhc19ob3N0X3JlZnJlc2goc3RydWN0IG1waTNtcl9p
b2MgKm1yaW9jKQogCQkgICAgKE1QSTNfU0FTSU9VTklUMF9QSFlGTEFHU19IT1NUX1BIWSB8CiAJ
CSAgICAgTVBJM19TQVNJT1VOSVQwX1BIWUZMQUdTX1ZJUlRVQUxfUEhZKSkKIAkJCWNvbnRpbnVl
OwotCQlsaW5rX3JhdGUgPQotCQkgICAgc2FzX2lvX3VuaXRfcGcwLT5waHlfZGF0YVtpXS5uZWdv
dGlhdGVkX2xpbmtfcmF0ZSA+PiA0OworCQlsaW5rX3JhdGUgPSBtcGkzbXJfZ2V0X3Nhc19waHlf
bGlua19yYXRlKAorCQkgICAgc2FzX2lvX3VuaXRfcGcwLT5waHlfZGF0YVtpXS5uZWdvdGlhdGVk
X2xpbmtfcmF0ZSk7CiAJCWlmICghbXJpb2MtPnNhc19oYmEuaGFuZGxlKQogCQkJbXJpb2MtPnNh
c19oYmEuaGFuZGxlID0gbGUxNl90b19jcHUoc2FzX2lvX3VuaXRfcGcwLT4KIAkJCSAgICBwaHlf
ZGF0YVtpXS5jb250cm9sbGVyX2Rldl9oYW5kbGUpOwpAQCAtMzI2NCw3ICszMjc0LDcgQEAgb3V0
OgogfQogCiAvKioKLSAqIG1waTNtcl9nZXRfc2FzX25lZ290aWF0ZWRfbG9naWNhbF9saW5rcmF0
ZSAtIGdldCBsaW5rcmF0ZQorICogbXBpM21yX2dldF9zYXNfbmVnb3RpYXRlZF9waHlzX2xpbmty
YXRlIC0gZ2V0IHBoeXNpY2FsIGxpbmsgcmF0ZQogICogQG1yaW9jOiBBZGFwdGVyIGluc3RhbmNl
IHJlZmVyZW5jZQogICogQHRndGRldjogVGFyZ2V0IGRldmljZQogICoKQEAgLTMyNzMsOSArMzI4
Myw5IEBAIG91dDoKICAqIHZhbHVlIGlzIG5vdCBhdmFpbGFibGUgb3IgaW52YWxpZCwgaXQgZmFs
bHMgYmFjayB0byByZWFkaW5nIGZyb20KICAqIHNhcyBwaHkgcGFnZTAgb3IgZXhwYW5kZXIgcGh5
IHBhZ2UxLgogICoKLSAqIFJldHVybjogbG9naWNhbCBsaW5rIHJhdGUuCisgKiBSZXR1cm46IHBo
eXNpY2FsIGxpbmsgcmF0ZS4KICAqLwotc3RhdGljIHU4IG1waTNtcl9nZXRfc2FzX25lZ290aWF0
ZWRfbG9naWNhbF9saW5rcmF0ZShzdHJ1Y3QgbXBpM21yX2lvYyAqbXJpb2MsCitzdGF0aWMgdTgg
bXBpM21yX2dldF9zYXNfbmVnb3RpYXRlZF9waHlzX2xpbmtyYXRlKHN0cnVjdCBtcGkzbXJfaW9j
ICptcmlvYywKIAlzdHJ1Y3QgbXBpM21yX3RndF9kZXYgKnRndGRldikKIHsKIAl1OCBsaW5rX3Jh
dGUgPSBNUEkzX1NBU19ORUdfTElOS19SQVRFXzFfNSwgcGh5X251bWJlcjsKQEAgLTMzMjgsOSAr
MzMzOCw3IEBAIHN0YXRpYyB1OCBtcGkzbXJfZ2V0X3Nhc19uZWdvdGlhdGVkX2xvZ2ljYWxfbGlu
a3JhdGUoc3RydWN0IG1waTNtcl9pb2MgKm1yaW9jLAogCWxpbmtfcmF0ZSA9IHBoeV9wZzAubmVn
b3RpYXRlZF9saW5rX3JhdGU7CiAKIG91dDoKLQlyZXR1cm4gKChsaW5rX3JhdGUgJgotCQlNUEkz
X1NBU19ORUdfTElOS19SQVRFX0xPR0lDQUxfTUFTSykgPj4KLQkJTVBJM19TQVNfTkVHX0xJTktf
UkFURV9MT0dJQ0FMX1NISUZUKTsKKwlyZXR1cm4gbXBpM21yX2dldF9zYXNfcGh5X2xpbmtfcmF0
ZShsaW5rX3JhdGUpOwogfQogCiAvKioKQEAgLTMzODEsNyArMzM4OSw3IEBAIGludCBtcGkzbXJf
cmVwb3J0X3RndGRldl90b19zYXNfdHJhbnNwb3J0KHN0cnVjdCBtcGkzbXJfaW9jICptcmlvYywK
IAl9CiAJdGd0ZGV2LT5kZXZfc3BlYy5zYXNfc2F0YV9pbmYuaGJhX3BvcnQgPSBoYmFfcG9ydDsK
IAotCWxpbmtfcmF0ZSA9IG1waTNtcl9nZXRfc2FzX25lZ290aWF0ZWRfbG9naWNhbF9saW5rcmF0
ZShtcmlvYywgdGd0ZGV2KTsKKwlsaW5rX3JhdGUgPSBtcGkzbXJfZ2V0X3Nhc19uZWdvdGlhdGVk
X3BoeXNfbGlua3JhdGUobXJpb2MsIHRndGRldik7CiAKIAlpZiAobGlua19yYXRlIDwgTVBJM19T
QVNfTkVHX0xJTktfUkFURV8xXzUpCiAJCWxpbmtfcmF0ZSA9IE1QSTNfU0FTX05FR19MSU5LX1JB
VEVfMV81OwotLSAKMi40Ny4zCgo=
--0000000000009463620657d8c0dd
Content-Type: text/markdown; charset="UTF-8"; 
	name="mpi3mr_link_rate_and_ub_full_report_en.md"
Content-Disposition: attachment; 
	filename="mpi3mr_link_rate_and_ub_full_report_en.md"
Content-Transfer-Encoding: base64
Content-ID: <f_ms7v3woi1>
X-Attachment-Id: f_ms7v3woi1

IyBUZWNobmljYWwgcmVwb3J0OiBpbmNvcnJlY3QgU0FTIFBIWSBsaW5rLXJhdGUgcmVwb3J0aW5n
IGFuZCB1bmRlZmluZWQgYmVoYXZpb3IgaW4gYG1waTNtcmAKCiMjIDEuIFN1bW1hcnkKClR3byBp
bmRlcGVuZGVudCBkZWZlY3RzIGluIHRoZSBTQVMgVHJhbnNwb3J0IExheWVyIGhhdmUgYmVlbiBj
b25maXJtZWQgb24gYSBCcm9hZGNvbSBlSEJBIDk2MDAgLyBTQVM0MDE2IEIwIHJ1bm5pbmcgdGhl
IGBtcGkzbXIgOC4xNy4xLjAuMGAgZHJpdmVyOgoKMS4gKipJbmNvcnJlY3QgcG9wdWxhdGlvbiBv
ZiBgc2FzX3BoeS0+bmVnb3RpYXRlZF9saW5rcmF0ZWAuKiogVGhlIGRyaXZlciB0YWtlcyB0aGUg
Kipsb2dpY2FsIG5lZ290aWF0ZWQgbGluayByYXRlKiogZnJvbSB0aGUgaGlnaCBuaWJibGUgb2Yg
dGhlIGBuZWdvdGlhdGVkX2xpbmtfcmF0ZWAgYnl0ZSwgd2hlcmVhcyB0aGUgTGludXggU0FTIFRy
YW5zcG9ydCBMYXllciBleHBlY3RzIHRoZSBwaHlzaWNhbCBQSFkgcmF0ZSBmcm9tIHRoZSBsb3cg
bmliYmxlLiBBcyBhIHJlc3VsdCwgTGludXggc3lzZnMgcmVwb3J0cyBgMS41IEdiaXRgIGZvciBw
aHlzaWNhbCBsaW5rcyB0aGF0IGFyZSBhY3R1YWxseSBydW5uaW5nIGF0IGAxMiBHYml0L3NgIGFu
ZCBgMjIuNSBHYml0L3NgLgoyLiAqKkdlbnVpbmUgdW5kZWZpbmVkIGJlaGF2aW9yIHdoZW4gYnVp
bGRpbmcgYHBoeV9tYXNrYC4qKiBUaGUgbWFzayBmaWVsZCBpcyBkZWNsYXJlZCBgdTY0YCwgYnV0
IGl0cyBiaXRzIGFyZSBzZXQgdXNpbmcgZXhwcmVzc2lvbnMgb2YgdGhlIGZvcm0gYCgxIDw8IGkp
YCwgd2hlcmUgYDFgIGhhcyB0eXBlIDMyLWJpdCBzaWduZWQgYGludGAuIEZvciBgaSA+PSAzMWAg
dGhpcyBleHByZXNzaW9uIGlzIHVuZGVmaW5lZCBiZWhhdmlvci4gT24gYW4gZXhwYW5kZXIgd2l0
aCA0NiBQSFlzIHRoaXMgcmVwcm9kdWNlcyB1bmRlciBVQlNBTiBhdCBgbXBpM21yX3RyYW5zcG9y
dC5jOjEwOTVgLiBJbiBhZGRpdGlvbiwgYGZmcygpYCBpcyBhcHBsaWVkIHRvIGEgYHU2NGAgZXZl
biB0aG91Z2ggaXQgb3BlcmF0ZXMgb24gYGludGAsIHNvIHRoZSB1cHBlciAzMiBiaXRzIG9mIHRo
ZSBtYXNrIGFyZSBsb3N0LgoKU2VwYXJhdGVseSwgVUJTQU4gcmVwb3J0cyBgYXJyYXktaW5kZXgt
b3V0LW9mLWJvdW5kc2Agb24gYWNjZXNzZXMgdG8gYHBoeV9kYXRhW2ldYC4gSW4gdGhlIHNoaXBw
ZWQgTVBJMyBoZWFkZXIgdGhlIGZpZWxkIGlzIGRlY2xhcmVkIGFzIGEgc2luZ2xlLWVsZW1lbnQg
dHJhaWxpbmcgYXJyYXkgYHBoeV9kYXRhWzFdYCwgd2hpbGUgdGhlIGRyaXZlciBkeW5hbWljYWxs
eSBhbGxvY2F0ZXMgYSBsYXJnZXIgYnVmZmVyLiBUaGlzIGlzIG1vc3QgbGlrZWx5IGEgdmlvbGF0
aW9uIG9mIHRoZSBkZWNsYXJlZCBhcnJheSBib3VuZCAvIGFuIG9ic29sZXRlIHRyYWlsaW5nLWFy
cmF5IGlkaW9tIHJhdGhlciB0aGFuIGEgcHJvdmVuIG92ZXJydW4gb2YgdGhlIGFjdHVhbGx5IGFs
bG9jYXRlZCBoZWFwIGJ1ZmZlci4gRXZlbiBzbywgdGhpcyBjb2RlIHNob3VsZCBiZSBjb252ZXJ0
ZWQgdG8gYSBmbGV4aWJsZS1hcnJheSBtZW1iZXIgYW5kIHN1cHBsZW1lbnRlZCB3aXRoIGEgY2hl
Y2sgb2YgdGhlIGFjdHVhbCBwYWdlIGxlbmd0aC4KCiMjIyBDb25maWRlbmNlIGxldmVscwoKfCBG
aW5kaW5nCQkJCQkJCQkJCQkJCSB8IENvbmZpZGVuY2UgfCBCYXNpcyAJCQkJCQkJCQkJCQkJCQkJ
CQkJCQkJCQkJCQkJCQkgICB8Cgp8IGBtcGkzbXJgIHN1YnN0aXR1dGVzIHRoZSBsb2dpY2FsIHJh
dGUgZm9yIHRoZSBwaHlzaWNhbCByYXRlfCBWZXJ5IGhpZ2ggIHwgQml0LWxldmVsIE1QSTMgZGVm
aW5pdGlvbiwgZXhhY3Qgc291cmNlIGxpbmVzLCBjb21wYXJpc29uIGFnYWluc3QgYG1wdDNzYXNg
LCBpbmRlcGVuZGVudCBtZWFzdXJlbWVudCBvbiB0aGUgTWljcm9jaGlwIGV4cGFuZGVyIHwKfCBg
KDEgPDwgaSlgIGNhdXNlcyBVQgkJCQkJCQkJCQkgfCBDZXJ0YWluICAgIHwgQyBsYW5ndWFnZSBy
dWxlcywgZXhhY3Qgc291cmNlLCBhY3R1YWwgVUJTQU4gcmVwb3J0CQkJCQkJCQkJCQkJCQkJCQkJ
CSAgIHwKfCBgZmZzKHU2NClgIGxvc2VzIHRoZSB1cHBlciBiaXRzCQkJCQkJCSB8IENlcnRhaW4g
ICAgfCBgcGh5X21hc2tgIGlzIGB1NjRgLCB0aGUgYGZmcygpYCBpbnRlcmZhY2UgdGFrZXMgYGlu
dGAJCQkJCQkJCQkJCQkJCQkJCQkgICB8CnwgVGhlIFVCU0FOIGFycmF5LWluZGV4IHJlcG9ydCBt
ZWFucyByZWFsIG1lbW9yeSBjb3JydXB0aW9uICB8IE5vdCBwcm92ZW4gfCBUaGUgYnVmZmVyIGlz
IGFsbG9jYXRlZCBkeW5hbWljYWxseSBiYXNlZCBvbiBgbnVtX3BoeXNgLCBidXQgdGhlIHN0cnVj
dCB0eXBlIGRlY2xhcmVzIGFuIGFycmF5IG9mIGxlbmd0aCAxIAkJCQkJICAgfAoKIyMjIFVwc3Ry
ZWFtIHN0YXR1cyBhcyBvZiAzMCBKdWx5IDIwMjYKCkEgcmV2aWV3IG9mIHRoZSBjdXJyZW50IExp
bnV4IGBtYXN0ZXJgIHRyZWUgc2hvd3MgdGhhdCB0aGUgZGVmZWN0cyBhcmUgbm90IGxpbWl0ZWQg
dG8gdGhlIGA4LjE3LjEuMC4wYCB2ZW5kb3IgcGFja2FnZToKCi0gYGRyaXZlcnMvc2NzaS9tcGkz
bXIvbXBpM21yX3RyYW5zcG9ydC5jYCBzdGlsbCBwb3B1bGF0ZXMgYHNhc19waHktPm5lZ290aWF0
ZWRfbGlua3JhdGVgIHZpYSBgTVBJM19TQVNfTkVHX0xJTktfUkFURV9MT0dJQ0FMX01BU0tgIGZv
ciBib3RoIGhvc3QgUEhZcyBhbmQgZXhwYW5kZXIgUEhZczsKLSBgc3RydWN0IG1waTNtcl9zYXNf
cG9ydGAgc3RpbGwgY29udGFpbnMgYHU2NCBwaHlfbWFza2AsIHlldCB0aGUgYWRkL2RlbGV0ZSBw
YXRocyB1c2UgYCgxIDw8IHBoeV9pZClgIGZvbGxvd2VkIGJ5IGBmZnMocGh5X21hc2spYDsKLSBi
eSBjb250cmFzdCwgdGhlIGN1cnJlbnQgYG1wdDNzYXNfdHJhbnNwb3J0LmNgIHN0aWxsIHVzZXMg
YE1QSTJfU0FTX05FR19MSU5LX1JBVEVfTUFTS19QSFlTSUNBTGAgd2hlbiBwb3B1bGF0aW5nIHRo
ZSBzYW1lIExpbnV4IFNBUyBUcmFuc3BvcnQgTGF5ZXIgZmllbGQuCgpUaGUgaXNzdWUgc2hvdWxk
IHRoZXJlZm9yZSBiZSByYWlzZWQgd2l0aCBCcm9hZGNvbSBhbmQgd2l0aCB1cHN0cmVhbSBgbGlu
dXgtc2NzaWAgYXQgdGhlIHNhbWUgdGltZTogYSBmaXggaXMgbmVlZGVkIGZvciB0aGUgY3VycmVu
dCBrZXJuZWwsIHBsdXMgYSBiYWNrcG9ydCBpbnRvIHRoZSBkaXN0cmlidXRlZCBCcm9hZGNvbSBk
cml2ZXIgcGFja2FnZS4KCiMjIDIuIENvbmZpZ3VyYXRpb24gdW5kZXIgdGVzdAoKIyMjIENvbnRy
b2xsZXIgOTYwMAoKLSBCcm9hZGNvbSBlSEJBIDk2MDAtMTZlLCBBU0lDIGBTQVM0MDE2IEIwYC4K
LSBQQ0kgYWRkcmVzczogYDAwMDA6MzI6MDAuMGAuCi0gV1dJRDogYDUwMDA2MmIyOjIwZWU5NTAw
YC4KLSBGaXJtd2FyZTogYDguMTcuMS4wLTAwMDAwLTAwMDAxYCwgZmlybXdhcmUgcGFja2FnZSBg
OC4xNy4xLjAuMDAwMDAtMDAwMDJgLgotIE1vZGUgZHVyaW5nIHJlcHJvZHVjdGlvbjogYFBlcmYt
SVQgKFNBUyBPbmx5KWAuCi0gTGludXggZHJpdmVyOiBgbXBpM21yIDguMTcuMS4wLjBgLgotIFRo
ZSBkcml2ZXIgcmVwb3J0cyAzOSBjb250cm9sbGVyIFBIWXMgYW5kIGEgNDYtUEhZIGV4cGFuZGVy
LgoKIyMjIFJlZmVyZW5jZSBjb250cm9sbGVyIDk1MDAKCi0gQnJvYWRjb20gSEJBIDk1MDAgLyBB
U0lDIGBTQVMzODE2IEEwYC4KLSBQQ0kgYWRkcmVzczogYDAwMDA6Y2E6MDAuMGAuCi0gV1dJRDog
YDUwMDA2MmIyOjA5ZTA1NzQwYC4KLSBGaXJtd2FyZTogYDM4LjAwLjAwLjAwYC4KLSBMaW51eCBk
cml2ZXI6IGBtcHQzc2FzIDU3LjAwLjAwLjAwYC4KCiMjIyBTaGFyZWQgdG9wb2xvZ3kKCkJvdGgg
Y29udHJvbGxlcnMgYXJlIGF0dGFjaGVkIHRvIHRoZSBzYW1lIE1pY3JvY2hpcCBTWFAgMjRHLCBw
cmVzZW50ZWQgYXMgYFNYUCA0MngyNEcgUmV2QmAuIFRoZSBzYW1lIGV4cGFuZGVyIGlzIHJlYWNo
YWJsZToKCi0gdGhyb3VnaCBgbXB0M3Nhc2A6IGAvZGV2L3NnMTFgOwotIHRocm91Z2ggYG1waTNt
cmA6IGAvZGV2L3NnMjBgLgoKVGhpcyBpcyBwcmVjaXNlbHkgd2h5IHRoZSBjb21wYXJpc29uIGRv
ZXMgbm90IGRlcGVuZCBvbiBkaWZmZXJlbnQgZHJpdmVzLCBkaWZmZXJlbnQgY2FibGVzIG9yIGRp
ZmZlcmVudCBleHBhbmRlcnM6IHRoZSB2YWx1ZXMgYXJlIHJlYWQgZm9yIHRoZSAqc2FtZSogbG9j
YWwgTWljcm9jaGlwIFBIWXMgdGhyb3VnaCB0d28gaW5kZXBlbmRlbnQgaW5pdGlhdG9yIHBhdGhz
LgoKIyMgMy4gRGVmZWN0ICMxOiB0aGUgbG9naWNhbCByYXRlIGlzIHVzZWQgYXMgdGhlIHBoeXNp
Y2FsIFBIWSByYXRlCgojIyMgMy4xLiBNUEkzIGZpZWxkIGZvcm1hdAoKYG1waS9tcGkzMF9jbmZn
LmhgIG9mIHRoZSBgbXBpM21yIDguMTcuMS4wLjBgIGRyaXZlciBkZWZpbmVzOgoKYGBgYwojZGVm
aW5lIE1QSTNfU0FTX05FR19MSU5LX1JBVEVfTE9HSUNBTF9NQVNLICAgICAgKDB4ZjApCiNkZWZp
bmUgTVBJM19TQVNfTkVHX0xJTktfUkFURV9MT0dJQ0FMX1NISUZUICAgICAoNCkKI2RlZmluZSBN
UEkzX1NBU19ORUdfTElOS19SQVRFX1BIWVNJQ0FMX01BU0sgICAgICgweDBmKQojZGVmaW5lIE1Q
STNfU0FTX05FR19MSU5LX1JBVEVfUEhZU0lDQUxfU0hJRlQgICAgKDApCmBgYAoKQSBzaW5nbGUg
Ynl0ZSB0aGVyZWZvcmUgY2FycmllcyAqKnR3byBpbmRlcGVuZGVudCB2YWx1ZXMqKjoKCi0gYml0
cyBgWzc6NF1gIOKAlCBsb2dpY2FsIG5lZ290aWF0ZWQgbGluayByYXRlOwotIGJpdHMgYFszOjBd
YCDigJQgcGh5c2ljYWwgbmVnb3RpYXRlZCBsaW5rIHJhdGUuCgpUaGUgTGludXggYHNhc19waHlg
IG9iamVjdCBhbmQgdGhlIGBuZWdvdGlhdGVkX2xpbmtyYXRlYCBzeXNmcyBhdHRyaWJ1dGUgYXJl
IG1lYW50IHRvIGRlc2NyaWJlIHRoZSBzdGF0ZSBvZiBhIHNwZWNpZmljIHBoeXNpY2FsIFBIWS4g
VGhpcyBpcyBhbHNvIGJvcm5lIG91dCBieSB0aGUgbG9uZy1lc3RhYmxpc2hlZCBiZWhhdmlvdXIg
b2YgYG1wdDNzYXNgLCB3aGljaCBzZWxlY3RzIHRoZSBsb3cgcGh5c2ljYWwgbmliYmxlIGZvciB0
aGUgc2FtZSBhdHRyaWJ1dGUuCgojIyMgMy4yLiBXaGF0IGBtcGkzbXJgIGRvZXMKCkluIHRoZSBz
aGlwcGVkIGBtcGkzbXJfdHJhbnNwb3J0LmNgLCB0aGUgbG9naWNhbCBoaWdoIG5pYmJsZSBpcyB1
c2VkIGluIGV2ZXJ5IHByaW5jaXBhbCBwYXRoIHRoYXQgc2V0cyBvciByZWZyZXNoZXMgdGhlIHJh
dGU6Cgp8IFBhdGggfCBWZW5kb3Igc291cmNlIGxpbmVzIHwgQWN0dWFsIG9wZXJhdGlvbiB8Cnwt
LS18LS0tOnwtLS18CnwgSG9zdCBQSFkgYWRkIHwgMTM0OOKAkzEzNTEgfCBgTE9HSUNBTF9NQVNL
ID4+IExPR0lDQUxfU0hJRlRgIHwKfCBFeHBhbmRlciBQSFkgYWRkIHwgMTQxOeKAkzE0MjIgfCBg
TE9HSUNBTF9NQVNLID4+IExPR0lDQUxfU0hJRlRgIHwKfCBSYXRlIHJlZnJlc2ggYWZ0ZXIgUEhZ
IG9wZXJhdGlvbiB8IDIxOTXigJMyMTk5IHwgYExPR0lDQUxfTUFTSyA+PiBMT0dJQ0FMX1NISUZU
YCB8CnwgRXhwYW5kZXIgbGluayB1cGRhdGUgfCAyODMz4oCTMjgzNSB8IGBMT0dJQ0FMX01BU0sg
Pj4gTE9HSUNBTF9TSElGVGAgfAp8IEhvc3QgUEhZIHJlZnJlc2ggfCAzMDgzIHwgZGlyZWN0IGA+
PiA0YCB8CnwgR2V0dGluZyB0aGUgbmVnb3RpYXRlZCByYXRlIGZvciBhIHRhcmdldCB8IDMzMjTi
gJMzMzI2IHwgYExPR0lDQUxfTUFTSyA+PiBMT0dJQ0FMX1NISUZUYCB8CgpFeGFtcGxlIGZyb20g
YG1waTNtcl9hZGRfZXhwYW5kZXJfcGh5KClgOgoKYGBgYwpwaHktPm5lZ290aWF0ZWRfbGlua3Jh
dGUgPSBtcGkzbXJfY29udmVydF9waHlfbGlua19yYXRlKAogICAgKGV4cGFuZGVyX3BnMS5uZWdv
dGlhdGVkX2xpbmtfcmF0ZSAmCiAgICAgTVBJM19TQVNfTkVHX0xJTktfUkFURV9MT0dJQ0FMX01B
U0spID4+CiAgICAgTVBJM19TQVNfTkVHX0xJTktfUkFURV9MT0dJQ0FMX1NISUZUKTsKYGBgCgpU
aGF0IGlzLCB0aGUgY29kZSBkZWxpYmVyYXRlbHkgZXh0cmFjdHMgdGhlIGhpZ2ggbmliYmxlIGV2
ZW4gdGhvdWdoIGEgc2VwYXJhdGUgYFBIWVNJQ0FMX01BU0tgIGlzIGRlZmluZWQgcmlnaHQgbmV4
dCB0byBpdC4KCiMjIyAzLjMuIFdoYXQgYG1wdDNzYXNgIGRvZXMKCkluIGBtcHQzc2FzX3RyYW5z
cG9ydC5jYCwgdGhlIHBoeXNpY2FsIGxvdyBuaWJibGUgaXMgdXNlZCBmb3IgdGhlIHNhbWUgTGlu
dXggU0FTIFRyYW5zcG9ydCBMYXllciBmaWVsZDoKCmBgYGMKcGh5LT5uZWdvdGlhdGVkX2xpbmty
YXRlID0gX3RyYW5zcG9ydF9jb252ZXJ0X3BoeV9saW5rX3JhdGUoCiAgICBwaHlfcGcwLk5lZ290
aWF0ZWRMaW5rUmF0ZSAmCiAgICBNUEkyX1NBU19ORUdfTElOS19SQVRFX01BU0tfUEhZU0lDQUwp
OwpgYGAKClRoZSBzYW1lIGlzIGRvbmUgZm9yIGV4cGFuZGVyIFBIWXMgYW5kIGZvciB0aGUgUEhZ
IFBhZ2UgMCByZS1yZWFkLiBQcmluY2lwYWwgdmVuZG9yIHNvdXJjZSBsb2NhdGlvbnM6CgotIGhv
c3QgUEhZOiBsaW5lcyAxMTc54oCTMTE4MDsKLSBleHBhbmRlciBQSFk6IGxpbmVzIDEyNTjigJMx
MjYwOwotIHJlZnJlc2g6IGxpbmVzIDIxMjXigJMyMTI3LgoKIyMjIDMuNC4gSGFyZHdhcmUgY29t
cGFyaXNvbiBvZiBgbXBpM21yYCBhbmQgYG1wdDNzYXNgCgpWYWx1ZXMgYmVsb3cgYXJlIGZvciB0
aGUgKnNhbWUqIE1pY3JvY2hpcCBsb2NhbCBQSFlzLiBUaGUgTWljcm9jaGlwIGNvbHVtbiBnaXZl
cyBhbiBpbmRlcGVuZGVudCBjbGFzc2lmaWNhdGlvbiBvZiB0aGUgcGh5c2ljYWwgcmF0ZSBvYnRh
aW5lZCBmcm9tIHBhZ2UgYDB4ODRgIEVPTSBjYXB0dXJlLgoKfCBNaWNyb2NoaXAgUEhZIHwgVmlh
IDk1MDAgLyBgbXB0M3Nhc2Agc3lzZnMgfCBWaWEgOTYwMCAvIGBtcGkzbXJgIHN5c2ZzIHwgTWlj
cm9jaGlwIHBoeXNpY2FsLXJhdGUgZXZpZGVuY2UgfCBWZXJkaWN0CQkgfAp8IDE3CQkJfCAyMi41
IEdiaXQvcyAJCQkJIHwgMS41IEdiaXQvcwkJCQkgfCAyMi41IEdiaXQvcwkJCQkJCXwgYG1waTNt
cmAgd3JvbmcgfAp8IDE4CQkJfCAxMi4wIEdiaXQvcyAJCQkJIHwgMS41IEdiaXQvcyAJCQkJIHwg
MTIuMCBHYml0L3MgCQkJCQkJfCBgbXBpM21yYCB3cm9uZyB8CnwgMTkJCQl8IDEyLjAgR2JpdC9z
IAkJCQkgfCAxLjUgR2JpdC9zIAkJCQkgfCAxMi4wIEdiaXQvcyAJCQkJCQl8IGBtcGkzbXJgIHdy
b25nIHwKfCAyNCAJCQl8IDIyLjUgR2JpdC9zIAkJCQkgfCAxLjUgR2JpdC9zIAkJCQkgfCAyMi41
IEdiaXQvcyAJCQkJCQl8IGBtcGkzbXJgIHdyb25nIHwKfCAyNSAJCQl8IDIyLjUgR2JpdC9zIAkJ
CQkgfCAxLjUgR2JpdC9zICAJCQkJIHwgMjIuNSBHYml0L3MgCQkJCQkJfCBgbXBpM21yYCB3cm9u
ZyB8CnwgMjYgCQkJfCAyMi41IEdiaXQvcyAJCQkJIHwgMS41IEdiaXQvcwkJCQkgfCAyMi41IEdi
aXQvcyAJCQkJCQl8IGBtcGkzbXJgIHdyb25nIHwKfCAyNyAJCQl8IDIyLjUgR2JpdC9zCQkJCSB8
IDEuNSBHYml0L3MgCQkJCSB8IDIyLjUgR2JpdC9zIAkJCQkJCXwgYG1waTNtcmAgd3JvbmcgfAp8
IDI4IAkJCXwgMTIuMCBHYml0L3MgCQkJCSB8IDEuNSBHYml0L3MJCQkJIHwgMTIuMCBHYml0L3MJ
CQkJCQl8IGBtcGkzbXJgIHdyb25nIHwKCkNvbnRyb2wgUEhZcyAw4oCTMyBhbmQgMTLigJMxNSBy
ZXBvcnQgaWRlbnRpY2FsIHZhbHVlcyB0aHJvdWdoIGJvdGggZHJpdmVycywgYmVjYXVzZSBvbiB0
aG9zZSBQSFlzIHRoZSBsb2dpY2FsIGFuZCBwaHlzaWNhbCBuaWJibGVzIGhhcHBlbiB0byBtYXRj
aCBpbiB0aGlzIHN0YXRlLiBUaGUgZGVmZWN0IGNhbiB0aGVyZWZvcmUgc3RheSB1bm5vdGljZWQg
Zm9yIGEgbG9uZyB0aW1lIGluIGEgaG9tb2dlbmVvdXMgdG9wb2xvZ3kgYW5kIG9ubHkgc2hvd3Mg
dXAgb24gUEhZcyB3aGVyZSB0aGUgdHdvIGZpZWxkcyBkaWZmZXIuCgojIyMgMy41LiBXaHkgdGhp
cyBpcyBub3QgYSBNaWNyb2NoaXAgdG9vbGluZyBlcnJvcgoKVGhlIG9ic2VydmF0aW9uIGlzIGNv
cnJvYm9yYXRlZCBieSB0aHJlZSBpbmRlcGVuZGVudCBsaW5lcyBvZiBldmlkZW5jZToKCjEuIGBt
cHQzc2FzYCwgb24gdGhlIHNhbWUgZXhwYW5kZXIgYW5kIHRoZSBzYW1lIFBIWXMsIHJlcG9ydHMg
MTIvMjIuNSBHYml0L3MuCjIuIE1pY3JvY2hpcCBFT00gY2FwdHVyZSB5aWVsZHMgcGh5c2ljYWwg
Y291bnQgcmF0ZXMgY29uc2lzdGVudCB3aXRoIDEyLzIyLjUgR2JpdC9zLgozLiBgbXBpM21yYCBp
cyB0aGUgb25seSBzb3VyY2Ugb2YgdGhlIDEuNSBHYml0L3MgdmFsdWUsIGFuZCBpdHMgc291cmNl
IGNvZGUgZXhwbGljaXRseSBzZWxlY3RzIHRoZSBsb2dpY2FsIGhpZ2ggbmliYmxlLgoKRm9yIGEg
Y29uY2x1c2l2ZSB2ZW5kb3IgY2FwdHVyZSBpdCB3b3VsZCBhbHNvIGhlbHAgdG8gcmVjb3JkIHRo
ZSByYXcgYG5lZ290aWF0ZWRfbGlua19yYXRlYCBieXRlIGZyb20gTVBJMyBTQVMgUEhZIFBhZ2Ug
MCAvIFNBUyBFeHBhbmRlciBQYWdlIDEuIEJhc2VkIG9uIHRoZSBvYnNlcnZlZCByZXN1bHQsIHRo
ZSBleHBlY3RlZCBjb21iaW5hdGlvbnMgYXJlIGEgbG9naWNhbCBjb2RlIGVxdWl2YWxlbnQgdG8g
YDEuNUdgIGluIHRoZSBoaWdoIG5pYmJsZSBhbmQgYSBwaHlzaWNhbCBjb2RlIG9mIGAxMkdgL2Ay
Mi41R2AgaW4gdGhlIGxvdyBuaWJibGU7IHRoaXMgc2hvdWxkIGJlIGNvbmZpcm1lZCBmcm9tIHRo
ZSByYXcgYnl0ZSByYXRoZXIgdGhhbiB0cmVhdGVkIGFzIGFscmVhZHkgcHJvdmVuLgoKIyMjIDMu
Ni4gSW1wYWN0CgpUaGUgZGVmZWN0IHByb2JhYmx5IGRvZXMgbm90IGNoYW5nZSB0aGUgYWN0dWFs
IGRhdGEtcGF0aCByYXRlOiBpdCBtaXNyZXBvcnRzIHRoZSBzdGF0ZSB0byB0aGUgTGludXggU0FT
IFRyYW5zcG9ydCBMYXllci4gVGhlIG9wZXJhdGlvbmFsIGNvbnNlcXVlbmNlcyBhcmUgbmV2ZXJ0
aGVsZXNzIHNpZ25pZmljYW50OgoKLSBgc3lzZnNgIHNob3dzIGEgc3B1cmlvdXMgZG93bnNoaWZ0
IHRvIDEuNSBHYml0L3M7Ci0gYHNhc3V0aWxzYCwgaW52ZW50b3J5LCBtb25pdG9yaW5nIGFuZCBp
bi1ob3VzZSBkaWFnbm9zdGljIHNjcmlwdHMgcmVjZWl2ZSBpbmNvcnJlY3QgZGF0YTsKLSBhdXRv
bWF0aW9uIG1heSB0cmlnZ2VyIHVubmVjZXNzYXJ5IHJlc2V0cywgY2FibGUvZHJpdmUgcmVwbGFj
ZW1lbnRzLCBvciB3cm9uZ2x5IGNvbmRlbW4gYSBsaW5rOwotIGVycm9ycyBhbmQgZXllIG1lYXN1
cmVtZW50cyBjYW5ub3QgYmUgcmVsaWFibHkgY29ycmVsYXRlZCB3aXRoIHRoZSBQSFkgcmF0ZTsK
LSB0b3BvbG9neSByZWZyZXNoIGFuZCBsaW5rLXVwIGV2ZW50cyBrZWVwIG92ZXJ3cml0aW5nIHRo
ZSB2YWx1ZSB3aXRoIHRoZSBzYW1lIGluY29ycmVjdCBsb2dpY2FsIG5pYmJsZS4KCiMjIyAzLjcu
IFJlcXVpcmVkIGRpcmVjdGlvbiBvZiB0aGUgZml4CgpCcm9hZGNvbSBzaG91bGQgY29uZmlybSB0
aGUgc2VtYW50aWNzIG9mIHRoZSBNUEkzIGZpZWxkIGFuZCB0aGVuIGNvbnNpc3RlbnRseSBjaGFu
Z2UgKipldmVyeSBwYXRoIHRoYXQgcG9wdWxhdGVzIHRoZSBMaW51eCBgc2FzX3BoeS0+bmVnb3Rp
YXRlZF9saW5rcmF0ZWAgb3IgcGFzc2VzIGEgbGluayByYXRlIGludG8gYG1waTNtcl91cGRhdGVf
bGlua3MoKWAqKiBzbyB0aGF0IGl0IHVzZXM6CgotIGBNUEkzX1NBU19ORUdfTElOS19SQVRFX1BI
WVNJQ0FMX01BU0tgOwotIGBNUEkzX1NBU19ORUdfTElOS19SQVRFX1BIWVNJQ0FMX1NISUZUYC4K
ClRoZSBsb2dpY2FsIHJhdGUgbWF5IGJlIHJldGFpbmVkIGZvciBpbnRlcm5hbCBmaXJtd2FyZS9j
b25uZWN0aW9uLW1hbmFnZW1lbnQgcHVycG9zZXMsIGJ1dCBpdCBtdXN0IG5vdCBiZSBwdWJsaXNo
ZWQgYXMgdGhlIHBoeXNpY2FsIGBzYXNfcGh5YCByYXRlLiBBIHBvaW50IGZpeCBpbiBgbXBpM21y
X2FkZF9leHBhbmRlcl9waHkoKWAgYWxvbmUgaXMgbm90IHN1ZmZpY2llbnQ6IHRoZSBlcnJvciB3
b3VsZCByZXR1cm4gb24gdGhlIG5leHQgcmVmcmVzaC9saW5rIGV2ZW50LgoKIyMgNC4gRGVmZWN0
ICMyOiAzMi1iaXQgc2hpZnQgYWdhaW5zdCBhIDY0LWJpdCBgcGh5X21hc2tgCgojIyMgNC4xLiBU
eXBlIG1pc21hdGNoCgpJbiBgbXBpM21yLmhgOgoKYGBgYwp1NjQgcGh5X21hc2s7CmBgYAoKQnV0
IGBtcGkzbXJfdHJhbnNwb3J0LmNgIGNvbnRhaW5zIGV4cHJlc3Npb25zIHN1Y2ggYXM6CgpgYGBj
Cm1yX3Nhc19wb3J0LT5waHlfbWFzayB8PSAoMSA8PCBpKTsKbXJfc2FzX3BvcnQtPnBoeV9tYXNr
ICY9IH4oMSA8PCBtcl9zYXNfcGh5LT5waHlfaWQpOwpoX3BvcnRbal0ucGh5X21hc2sgfD0gKDEg
PDwgaSk7CmhfcG9ydFtwb3J0X2lkeF0ucGh5X21hc2sgPSAoMSA8PCBpKTsKYGBgCgpUaGUgbGVm
dCBvcGVyYW5kIGAxYCBoYXMgdHlwZSBzaWduZWQgYGludGAuIFRoZSBzaGlmdCBpcyBldmFsdWF0
ZWQgKipiZWZvcmUqKiB0aGUgYXNzaWdubWVudCBpbnRvIHRoZSBgdTY0YCwgc28gdGhlIDY0LWJp
dCB3aWR0aCBvZiB0aGUgZmllbGQgZG9lcyBub3QgbWFrZSB0aGUgZXhwcmVzc2lvbiBzYWZlLgoK
IyMjIDQuMi4gV2h5IHRoaXMgaXMgdW5kZWZpbmVkIGJlaGF2aW9yCgpGb3IgYSBjb252ZW50aW9u
YWwgMzItYml0IGBpbnRgOgoKLSBgMSA8PCAzMWAgYXR0ZW1wdHMgdG8gc2V0IHRoZSBzaWduIGJp
dCBhbmQgaGFzIG5vIGNvcnJlY3RseSByZXByZXNlbnRhYmxlIHBvc2l0aXZlIHJlc3VsdDsKLSBg
MSA8PCAzMmAgYW5kIGFueSB3aWRlciBzaGlmdCBoYXZlIGEgc2hpZnQgY291bnQgbm90IHNtYWxs
ZXIgdGhhbiB0aGUgd2lkdGggb2YgdGhlIHR5cGUuCgpCb3RoIGNhc2VzIGFyZSB1bmRlZmluZWQg
YmVoYXZpb3IgaW4gQy4gT24gYSA0Ni1QSFkgZXhwYW5kZXIsIGxvY2FsIFBIWSBpZGVudGlmaWVy
cyAzMuKAkzQ1IGFyZSB2YWxpZCwgc28gdGhlIHByb2JsZW0gaXMgbm90IHRoZW9yZXRpY2FsLgoK
IyMjIDQuMy4gQWN0dWFsIHJlcHJvZHVjdGlvbgoKRnJvbSB0aGUgcnVudGltZSBsb2c6CgpgYGB0
ZXh0ClVCU0FOOiBzaGlmdC1vdXQtb2YtYm91bmRzIGluIG1waTNtcl90cmFuc3BvcnQuYzoxMDk1
OjMxCldvcmtxdWV1ZTogbXBpM21yMF9md2V2dF93cmtyCm1waTNtcl9zYXNfcG9ydF9hZGQgLi4u
Cm1waTNtcl91cGRhdGVfbGlua3MgLi4uCm1waTNtcl9yZXBvcnRfdGd0ZGV2X3RvX3Nhc190cmFu
c3BvcnQgLi4uCmBgYAoKU291cmNlIGNvbnRleHQgZm9yIGxpbmUgMTA5NToKCmBgYGMKZm9yIChp
ID0gMDsgaSA8IG1yX3Nhc19ub2RlLT5udW1fcGh5czsgaSsrKSB7CiAgICAuLi4KICAgIG1yX3Nh
c19wb3J0LT5waHlfbWFzayB8PSAoMSA8PCBpKTsKfQpgYGAKCkltbWVkaWF0ZWx5IGJlZm9yZSB0
aGlzLCB0aGUgZHJpdmVyIHJlcG9ydHM6CgpgYGB0ZXh0Cmhvc3RfYWRkOiAuLi4gcGh5cygzOSkK
ZXhwYW5kZXJfYWRkOiAuLi4gcGh5cyg0NikKYGBgCgpBZnRlciBlaWdodCBkcml2ZXMgaGF2ZSBi
ZWVuIGFkZGVkLCB0aGUgd2FybmluZyBhcHBlYXJzIGp1c3QgYmVmb3JlIHRoZSBleHBhbmRlci9T
RVMgdGFyZ2V0IGlzIGFkZGVkLiBJbiB0aGUgcGFyYWxsZWwgYG1wdDNzYXNgIHRvcG9sb2d5IGxv
ZyB0aGF0IHRhcmdldCBpcyBib3VuZCB0byBleHBhbmRlciBQSFkgNDMsIHdoaWNoIGlzIGNvbnNp
c3RlbnQgd2l0aCBhIGAxIDw8IDQzYCB0cmlnZ2VyLgoKIyMjIDQuNC4gQSBzZWNvbmQgZXJyb3I6
IGBmZnMoKWAgb24gYSBgdTY0YAoKQWZ0ZXIgdGhlIG1hc2sgaGFzIGJlZW4gYnVpbHQsIHRoZSBj
b2RlIHBlcmZvcm1zOgoKYGBgYwptcl9zYXNfcG9ydC0+bG93ZXN0X3BoeSA9IGZmcyhtcl9zYXNf
cG9ydC0+cGh5X21hc2spIC0gMTsKYGBgCgpgZmZzKClgIG9wZXJhdGVzIG9uIGBpbnRgLiBQYXNz
aW5nIGEgYHU2NGAgdHJ1bmNhdGVzIGl0IHRvIHRoZSBsb3cgMzIgYml0cy4gQ29uc2VxdWVuY2Vz
OgoKLSBpZiBvbmx5IGEgUEhZID49IDMyIGlzIHNldCwgYGZmcygpYCBzZWVzIHplcm8gYW5kIGBs
b3dlc3RfcGh5YCBiZWNvbWVzIGAtMWA7Ci0gaWYgYm90aCBsb3cgYW5kIGhpZ2ggYml0cyBhcmUg
c2V0IHNpbXVsdGFuZW91c2x5LCB0aGUgdXBwZXIgaGFsZiBpcyBpZ25vcmVkIGVudGlyZWx5Owot
IHRoZSBsb2dpYyBmb3Igd2lkZS1wb3J0IG1lbWJlcnNoaXAsIHBvcnQgcmVtb3ZhbCBhbmQgbG93
ZXN0LVBIWSBzZWxlY3Rpb24gYmVjb21lcyB1bnJlbGlhYmxlLgoKIyMjIDQuNS4gUG90ZW50aWFs
IGNvbnNlcXVlbmNlcwoKLSBsb3NzIG9mIFBIWSAzMeKAkzYzIG1lbWJlcnNoaXAgaW4gdGhlIG1h
c2s7Ci0gaW5jb3JyZWN0IGBsb3dlc3RfcGh5YDsKLSBpbmNvcnJlY3Qgd2lkZS1wb3J0IGFnZ3Jl
Z2F0aW9uOwotIGluY29ycmVjdCBQSFkgYWRkL3JlbW92ZTsKLSBpbnN0YWJpbGl0eSBpbiB0aGUg
dG9wb2xvZ3kgcmVmcmVzaCwgaG90cGx1ZyBhbmQgcmVzZXQgcGF0aHM7Ci0gcG9zc2libGUgYXJi
aXRyYXJ5IGJlaGF2aW91cmFsIGNoYW5nZXMgZGVwZW5kaW5nIG9uIGNvbXBpbGVyL29wdGltaXph
dGlvbiBsZXZlbC4KClRoZSBvYnNlcnZlZCBpbmNvcnJlY3QgbGluayByYXRlIG9mIDEuNSBHYml0
L3MgKipzaG91bGQgbm90IGF1dG9tYXRpY2FsbHkgYmUgYXR0cmlidXRlZCB0byB0aGlzIFVCKiou
IFRoZSByYXRlIGVycm9yIGhhcyBhIHNlcGFyYXRlLCBkaXJlY3QgY2F1c2Ug4oCUIHRoZSBjaG9p
Y2Ugb2YgdGhlIGxvZ2ljYWwgbmliYmxlLiBUaGUgdHdvIGRlZmVjdHMgbXVzdCBiZSBmaXhlZCBh
bmQgdGVzdGVkIGluZGVwZW5kZW50bHkuCgojIyMgNC42LiBDb21wYXJpc29uIHdpdGggYG1wdDNz
YXNgCgpUaGUgYG1wdDNzYXNgIHZlbmRvciBzb3VyY2UgYWxzbyBjb250YWlucyBsZWdhY3kgYCgx
IDw8IGkpYCBleHByZXNzaW9ucywgYnV0IHRoZXkgYXJlIGFwcGxpZWQgdG8gdGhlIEhCQSBwb3J0
IG1hc2sgb25seSB3aGVuIGBzYXNfbm9kZWAgaXMgdGhlIGNvbnRyb2xsZXIgaG9zdCBub2RlLiBJ
biB0aGlzIGNvbmZpZ3VyYXRpb24gdGhlIDk1MDAgcmVwb3J0cyAyMSBob3N0IFBIWXMsIHNvIGEg
c2hpZnQgPj0gMzEgaXMgbmV2ZXIgcmVhY2hlZC4gRm9yIHRoZSA0Ni1QSFkgZXhwYW5kZXIsIGBt
cHQzc2FzYCBkb2VzIG5vdCBidWlsZCB0aGlzIGhvc3QgbWFzayBhbmQgbm8gVUJTQU4gd2Fybmlu
ZyBhcHBlYXJzLgoKVGhpcyBkb2VzICoqbm90KiogcHJvdmUgdGhhdCBhbGwgdmVyc2lvbnMgb2Yg
YG1wdDNzYXNgIGFyZSB1bml2ZXJzYWxseSBmcmVlIG9mIHNpbWlsYXIgMzItYml0IHNoaWZ0cy4g
SXQgc2hvd3MgdGhhdDoKCi0gdGhpcyBwYXJ0aWN1bGFyIGBtcHQzc2FzIDU3LjAwLjAwLjAwYCwg
aW4gdGhlIHRvcG9sb2d5IHVuZGVyIHRlc3QsIGRvZXMgbm90IHRyaWdnZXIgVUJTQU47Ci0gYG1w
aTNtcmAgc3RvcmVzIHRoZSBwZXItcG9ydCBtYXNrIGFzIGEgYHU2NGAgYnV0LCBpbiB2ZW5kb3Ig
Y29kZSwgYnVpbGRzIGl0IHdpdGggYSAzMi1iaXQgZXhwcmVzc2lvbiBhbmQgZ2VudWluZWx5IHBh
c3NlcyB0aHJvdWdoIFBIWSA0My4KCiMjIyA0LjcuIFJlcXVpcmVkIGRpcmVjdGlvbiBvZiB0aGUg
Zml4CgpBIGZ1bGwgYXVkaXQgb2YgZXZlcnkgYHBoeV9tYXNrYCBvcGVyYXRpb24gaXMgbmVlZGVk
OgoKLSBidWlsZCBiaXRzIHdpdGggYSA2NC1iaXQgb3BlcmF0aW9uIChgQklUX1VMTCgpYCBvciBl
cXVpdmFsZW50KTsKLSB2YWxpZGF0ZSBgcGh5X2lkIDwgNjRgOyBpZiBhIGZ1dHVyZSBBU0lDL2V4
cGFuZGVyIG1heSBoYXZlIG1vcmUgdGhhbiA2NCBQSFlzLCB1c2UgYW4gYXBwcm9wcmlhdGVseSBz
aXplZCBiaXRtYXA7Ci0gcmVwbGFjZSBgZmZzKClgIHdpdGggYSA2NC1iaXQgZmluZC1maXJzdC1i
aXQgb3IgYSBiaXRtYXAgQVBJOwotIGhhbmRsZSB0aGUgemVyby1tYXNrIGNhc2UgZXhwbGljaXRs
eSwgcmF0aGVyIHRoYW4gYWNjaWRlbnRhbGx5IGNvbXB1dGluZyBgLTFgOwotIHJldmlldyB0aGUg
dmVuZG9yIG9jY3VycmVuY2VzIG5lYXIgbGluZXMgODgyLCA5MDksIDEwOTUsIDI1MTggYW5kIDI1
NDUuCgojIyA1LiBVQlNBTiBgYXJyYXktaW5kZXgtb3V0LW9mLWJvdW5kc2Agb24gYHBoeV9kYXRh
W2ldYAoKIyMjIDUuMS4gT2JzZXJ2ZWQgbWVzc2FnZXMKClVCU0FOIHdhcm5pbmdzIHdlcmUgcmVj
b3JkZWQgZHVyaW5nIGluaXRpYWxpemF0aW9uL3JlZnJlc2g6CgotIGBtcGkzbXJfdHJhbnNwb3J0
LmM6MzE4MDozMmA7Ci0gYG1waTNtcl90cmFuc3BvcnQuYzozMjAwOjM4YDsKLSBgbXBpM21yX3Ry
YW5zcG9ydC5jOjMwNzg6MzJgOwotIGBtcGkzbXJfdHJhbnNwb3J0LmM6MzA4MzozMmA7Ci0gYG1w
aTNtcl90cmFuc3BvcnQuYzozMDg3OjM4YDsKLSBgbXBpM21yX3RyYW5zcG9ydC5jOjMxMDU6MjFg
LgoKQWxsIG9mIHRoZW0gcmVsYXRlIHRvIGFjY2Vzc2VzIG9mIHRoZSBmb3JtIGBzYXNfaW9fdW5p
dF9wZzAtPnBoeV9kYXRhW2ldYC4KCiMjIyA1LjIuIFRoZSB3YXJuaW5nIHN0ZW1zIGZyb20gdGhl
IHN0cnVjdCB0eXBlCgpJbiB0aGUgdmVuZG9yIGBtcGkzMF9jbmZnLmhgOgoKYGBgYwojZGVmaW5l
IE1QSTNfU0FTX0lPX1VOSVQwX1BIWV9NQVggKDEpCi4uLgpzdHJ1Y3QgbXBpM19zYXNfaW9fdW5p
dF9wYWdlMCB7CiAgICAuLi4KICAgIHN0cnVjdCBtcGkzX3Nhc19pb191bml0MF9waHlfZGF0YSBw
aHlfZGF0YVtNUEkzX1NBU19JT19VTklUMF9QSFlfTUFYXTsKfTsKYGBgCgpUaGUgZHJpdmVyIHRo
ZW4gYWxsb2NhdGVzOgoKYGBgYwpvZmZzZXRvZihzdHJ1Y3QgbXBpM19zYXNfaW9fdW5pdF9wYWdl
MCwgcGh5X2RhdGEpICsKbnVtX3BoeXMgKiBzaXplb2Yoc3RydWN0IG1waTNfc2FzX2lvX3VuaXQw
X3BoeV9kYXRhKQpgYGAKClNvIHRoZSBhY3R1YWwgYWxsb2NhdGlvbiBpcyBzaXplZCBmb3IgYG51
bV9waHlzYCwgd2hpbGUgdGhlIHN0YXRpYyB0eXBlIHN0aWxsIHRlbGxzIHRoZSBjb21waWxlciB0
aGF0IG9ubHkgaW5kZXggMCBpcyB2YWxpZC4gVUJTQU4gdGhlcmVmb3JlIGxlZ2l0aW1hdGVseSBm
bGFncyBhIHZpb2xhdGlvbiBvZiB0aGUgZGVjbGFyZWQgYXJyYXkgYm91bmQuCgojIyMgNS4zLiBX
aGF0IGlzIHByb3ZlbiBhbmQgd2hhdCBpcyBub3QKClByb3ZlbjoKCi0gdGhlIHZlbmRvciBzb3Vy
Y2UgdXNlcyBhbiBvYnNvbGV0ZSBvbmUtZWxlbWVudCB0YWlsOwotIGFjY2Vzc2VzIHRvIGBwaHlf
ZGF0YVtpXWAgd2l0aCBgaSA+IDBgIHZpb2xhdGUgdGhlIGJvdW5kIGtub3duIHRvIHRoZSBjb21w
aWxlcjsKLSB0aGUgVUJTQU4gd2FybmluZ3MgYXJlIHJlcHJvZHVjaWJsZS4KCk5vdCBwcm92ZW4g
ZnJvbSB0aGVzZSBtZXNzYWdlcyBhbG9uZToKCi0gdGhhdCBhIHJlYWQvd3JpdGUgd2VudCBiZXlv
bmQgdGhlIGFjdHVhbGx5IGFsbG9jYXRlZCBga3phbGxvYygpYCBidWZmZXI7Ci0gdGhhdCB0aGUg
ZmlybXdhcmUgcmV0dXJuZWQgYSBwYWdlIHNob3J0ZXIgdGhhbiB0aGUgcmVxdWVzdGVkIHNpemUu
CgpUaGlzIHNob3VsZCB0aGVyZWZvcmUgYmUgZGVzY3JpYmVkIHRvIEJyb2FkY29tIGFzIGEgKip0
eXBlL2JvdW5kcyBVQiBhbmQgc2FuaXRpemVyLXZpc2libGUgZGVmZWN0KiosIGFuZCBub3QsIHdp
dGhvdXQgZnVydGhlciBkYXRhLCBhcyBjb25maXJtZWQgaGVhcCBjb3JydXB0aW9uLgoKIyMjIDUu
NC4gUmVjb21tZW5kZWQgZml4CgotIHJlcGxhY2UgdGhlIG9uZS1lbGVtZW50IHRhaWwgd2l0aCBh
IGZsZXhpYmxlLWFycmF5IG1lbWJlcjsKLSBjb21wdXRlIHRoZSBhbGxvY2F0aW9uIHdpdGggYHN0
cnVjdF9zaXplKClgOwotIHZhbGlkYXRlIHRoZSBwYWdlIGxlbmd0aCBhbmQgYG51bV9waHlzYCBm
cm9tIHRoZSBDb25maWcgcmVwbHkgYmVmb3JlIGl0ZXJhdGluZzsKLSBib3VuZCB0aGUgbG9vcCBi
eSB0aGUgbWluaW11bSBvZiB0aGUgYWN0dWFsIGRlc2NyaXB0b3IgY291bnQsIHRoZSBwYWdlIGxl
bmd0aCBhbmQgdGhlIGFsbG9jYXRpb24gY2FwYWNpdHkuCgojIyA2LiBEcml2ZXIgY29tcGFyaXNv
biBzdW1tYXJ5Cgp8IEFzcGVjdAkJCQkJCQkJCSB8IGBtcGkzbXIgOC4xNy4xLjAuMGAgLyBTQVM0
MDE2IAkJCQkJICB8IGBtcHQzc2FzIDU3LjAwLjAwLjAwYCAvIFNBUzM4MTYJCQkJCQkJCQkJCQkg
CXwKCnwgU291cmNlIGZvciBgc2FzX3BoeS0+bmVnb3RpYXRlZF9saW5rcmF0ZWAgIHwgTG9naWNh
bCBoaWdoIG5pYmJsZSAJCQkgCQkJCQkgIHwgUGh5c2ljYWwgbG93IG5pYmJsZSAJCQkJCQkJCQkJ
CQkJCQl8CnwgUmVzdWx0IG9uIFBIWXMgMTfigJMxOSwgMjTigJMyOCAJCQkJIHwgU3B1cmlvdXMg
MS41IEdiaXQvcwkJCQkJCQkgIAkgIHwgTWF0Y2hlcyBNaWNyb2NoaXAgMTIvMjIuNSBHYml0L3MJ
CQkJCQkJCQkJCQl8CnwgQmVoYXZpb3VyIG9uIFBIWXMgd2hlcmUgdGhlIG5pYmJsZXMgbWF0Y2gg
IHwgRXJyb3IgaGlkZGVuIAkJCQkgCQkJCQkgIHwgQ29ycmVjdCAgCQkJCQkJCQkJCQkJCQkJCQkJ
fAp8IFBvcnQgbWFzayB0eXBlIAkJCQkJCQkgfCBgdTY0YCAJCQkJCQkJCQkJCSAgfCBIQkEgbWFz
ayBpbiBsZWdhY3kgdG9wb2xvZ3kgc3RydWN0dXJlcyAJCQkJCQkJCQkJCXwKfCBCaXQgY29uc3Ry
dWN0aW9uIAkJCQkJCQkgfCBgKDEgPDwgcGh5X2lkKWAgCQkJCSAJCQkJCSAgfCBMZWdhY3kgc2hp
ZnQgYWxzbyBwcmVzZW50LCBidXQgbGltaXRlZCBpbiB0aGlzIHRlc3QgdG8gYSBob3N0IG5vZGUg
d2l0aCAyMSBQSFlzIHwKfCBVQlNBTiBzaGlmdCB3YXJuaW5nIAkJCQkJCSB8IFJlcHJvZHVjZXMs
IGxpbmUgMTA5NSAJCSAJCQkJCSAgfCBOb3Qgb2JzZXJ2ZWQgaW4gdGhlIHByb3ZpZGVkIGxvZyAJ
CQkJCQkJCQkJCQl8CnwgNDYtUEhZIGV4cGFuZGVyIAkJCQkJCQkgfCBNYXNrIGJ1aWx0IGluIHRo
ZSBwcm9ibGVtYXRpYyB2ZW5kb3IgYG1waTNtcmAgcGF0aCB8IEV4cGFuZGVyIGluZGV4IGlzIG5v
dCBhZGRlZCB0byB0aGUgaG9zdCBIQkEgbWFzayBpbiB0aGUgcGF0aCB1bmRlciB0ZXN0IAkJfAp8
IFVCU0FOIGFycmF5LWJvdW5kIHdhcm5pbmdzIAkJCQkgfCBSZXByb2R1Y2UsIGR1ZSB0byBgcGh5
X2RhdGFbMV1gIAkJCQkJICB8IEFic2VudCBmcm9tIHRoZSBwcm92aWRlZCBsb2cgCQkJCQkJCQkJ
CQkJCXwKCiMjIDcuIE1pbmltYWwgcmVwcm9kdWNlciBmb3IgQnJvYWRjb20KCjEuIEF0dGFjaCBh
IFNBUzQwMTYvOTYwMCBhbmQgYSBTQVMzODE2Lzk1MDAgdG8gdGhlIHNhbWUgU0FTLTQgZXhwYW5k
ZXIgd2l0aCBtaXhlZC1yYXRlIHRhcmdldCBQSFlzLgoyLiBPbiB0aGUgOTYwMCwgc2VsZWN0IFBl
cmZJVCBTQVMgT25seSBzbyB0aGF0IGBtcGkzbXJgIGNyZWF0ZXMgdGhlIFNBUyBUcmFuc3BvcnQg
TGF5ZXIuIERvIG5vdCB1c2UgRmVhdHVyZUhCQSBmb3IgdGhlIHByaW1hcnkgcmVwcm9kdWNlcjog
d2l0aCBmaXJtd2FyZS1tYW5hZ2VkIG11bHRpcGF0aCwgU0FTIHRyYW5zcG9ydCBvYmplY3RzIG1h
eSBiZSBhYnNlbnQgYnkgZGVzaWduLgozLiBCb290IGEga2VybmVsIGJ1aWx0IHdpdGggYENPTkZJ
R19VQlNBTj15YCBhbmQgdGhlIGJvdW5kcy9zaGlmdCBjaGVja3MgZW5hYmxlZC4KNC4gQ2FwdHVy
ZToKICAgLSBgdW5hbWUgLWFgOwogICAtIGBtb2RpbmZvIG1waTNtcmAgYW5kIGBtb2RpbmZvIG1w
dDNzYXNgOwogICAtIGZpcm13YXJlL3BhY2thZ2UgdmVyc2lvbnMgb2YgYm90aCBIQkFzOwogICAt
IGBsc3BjaSAtbm52dmA7CiAgIC0gYGRtZXNnYCBmcm9tIHByb2JlIG9ud2FyZHM7CiAgIC0gZXZl
cnkgYC9zeXMvY2xhc3Mvc2FzX3BoeS8qL25lZ290aWF0ZWRfbGlua3JhdGVgIGFsb25nIGJvdGgg
aW5pdGlhdG9yIHBhdGhzOwogICAtIFNNUCBESVNDT1ZFUiBvciBleHBhbmRlciB2ZW5kb3Igc3Rh
dHVzIHNob3dpbmcgdGhlIHBoeXNpY2FsIG5lZ290aWF0ZWQgcmF0ZTsKICAgLSB0aGUgcmF3IE1Q
STMgU0FTIFBIWSBQYWdlIDAgLyBTQVMgRXhwYW5kZXIgUGFnZSAxIGBuZWdvdGlhdGVkX2xpbmtf
cmF0ZWAgYnl0ZS4KNS4gQ29tcGFyZSB0aGUgc2FtZSBsb2NhbCBleHBhbmRlciBQSFkgdGhyb3Vn
aCBgbXB0M3Nhc2AgYW5kIHRocm91Z2ggYG1waTNtcmAuCjYuIEZvciB0aGUgVUIsIG1ha2Ugc3Vy
ZSBhIHRhcmdldC9TRVAgaXMgcHJlc2VudCBvbiBhbiBleHBhbmRlciBQSFkgaWRlbnRpZmllciA+
PSAzMiwgZm9yIGV4YW1wbGUgUEhZIDQzLgoKIyMjIEV4cGVjdGVkIHJlc3VsdAoKLSBzeXNmcyBg
bmVnb3RpYXRlZF9saW5rcmF0ZWAgbWF0Y2hlcyB0aGUgcGh5c2ljYWwgbG93IG5pYmJsZSwgU01Q
IERJU0NPVkVSIGFuZCB0aGUgZXhwYW5kZXIgcGh5c2ljYWwgUEhZIHJhdGU7Ci0gUEhZIGlkZW50
aWZpZXJzIDDigJM2MyBhcmUgcmVwcmVzZW50ZWQgc2FmZWx5IGluIHRoZSBgdTY0YCBtYXNrOwot
IFVCU0FOIHJlcG9ydHMgbm8gc2hpZnQgb3IgYXJyYXktYm91bmQgdmlvbGF0aW9ucy4KCiMjIyBB
Y3R1YWwgcmVzdWx0CgotIGBtcGkzbXJgIHB1Ymxpc2hlcyB0aGUgbG9naWNhbCBoaWdoIG5pYmJs
ZSBhbmQgc2hvd3MgMS41IEdiaXQvcyBpbnN0ZWFkIG9mIDEyLzIyLjUgR2JpdC9zOwotIFVCU0FO
IHJlcG9ydHMgYHNoaWZ0LW91dC1vZi1ib3VuZHNgIGluIGBtcGkzbXJfc2FzX3BvcnRfYWRkKClg
OwotIFVCU0FOIHJlcG9ydHMgYGFycmF5LWluZGV4LW91dC1vZi1ib3VuZHNgIHdoZW4gcmVhZGlu
ZyBgcGh5X2RhdGFbaV1gLgoKIyMgOC4gUHJvcG9zZWQgcmVncmVzc2lvbiB0ZXN0cwoKIyMjIExp
bmstcmF0ZSB0ZXN0cwoKLSBQaHlzaWNhbC9sb2dpY2FsIHBhaXJzOiBgMS41LzEuNWAsIGAxLjUv
MTJgLCBgMS41LzIyLjVgLCBgMTIvMTJgLCBgMjIuNS8yMi41YC4KLSBIb3N0IFBIWXMgYW5kIGV4
cGFuZGVyIFBIWXMuCi0gSW5pdGlhbCBhZGQsIGRldmljZSBhZGQsIHRvcG9sb2d5IHJlZnJlc2gs
IGxpbmstdXAgZXZlbnQsIGxpbmsgcmVzZXQsIGV4cGFuZGVyIHJlc2V0IGFuZCBob3RwbHVnLgot
IFZlcmlmeSB0aGF0IGEgcmVwZWF0ZWQgZXZlbnQgZG9lcyBub3QgcmVzdG9yZSB0aGUgbG9naWNh
bCByYXRlIGluIHN5c2ZzLgoKIyMjIE1hc2sgdGVzdHMKCi0gUEhZIGlkZW50aWZpZXJzOiAwLCAz
MCwgMzEsIDMyLCA0MywgNDUsIDYzLgotIEFkZC9yZW1vdmUgb2YgYSBzaW5nbGUgUEhZIGFuZCBv
ZiBhIHdpZGUgcG9ydCB3aXRoIHNldmVyYWwgUEhZcyBvbiBib3RoIHNpZGVzIG9mIHRoZSAzMi1i
aXQgYm91bmRhcnkuCi0gWmVybyBtYXNrIGFmdGVyIHRoZSBsYXN0IFBIWSBpcyByZW1vdmVkLgot
IFZlcmlmaWNhdGlvbiBvZiBgbG93ZXN0X3BoeWAgYW5kIG9mIGZ1bGwgbWVtYmVyc2hpcC4KCiMj
IyBQYWdlLWJvdW5kIHRlc3RzCgotIGBudW1fcGh5cyA9IDFgLCAyMSwgMzksIDQ2IGFuZCA2NC4K
LSBBIHRydW5jYXRlZCBDb25maWcgcmVwbHkgYW5kIGFuIGluY29uc2lzdGVuY3kgYmV0d2VlbiBw
YWdlIGxlbmd0aCBhbmQgYG51bV9waHlzYC4KLSBVQlNBTi9LQVNBTi9LTVNBTiBidWlsZHMuCgoK
IyMgOS4gQ29uY2x1c2lvbgoKVGhlIHJhdGUgZXJyb3IgaXMgYSBkaXJlY3QsIHJlcHJvZHVjaWJs
ZSBzZW1hbnRpYyBidWc6IGBtcGkzbXJgIGV4cG9ydHMgdGhlIGxvZ2ljYWwgcmF0ZSB3aGVyZSBg
bXB0M3Nhc2AgYW5kIHRoZSBhY3R1YWwgUEhZIHVzZSB0aGUgcGh5c2ljYWwgcmF0ZS4gVGhlIHVu
ZGVmaW5lZCBiZWhhdmlvciBhcm91bmQgYHBoeV9tYXNrYCBpcyBhIHNlcGFyYXRlLCBjb25maXJt
ZWQgc2FuaXRpemVyIGRlZmVjdCBhbmQgaXMgcGFydGljdWxhcmx5IGRhbmdlcm91cyBvbiBhIDM5
LzQ2LVBIWSB0b3BvbG9neS4gVGhlIFVCU0FOIGFycmF5LWJvdW5kIHdhcm5pbmdzIGNhbGwgZm9y
IGEgYmFja3BvcnRlZCBmbGV4aWJsZS1hcnJheSBjb252ZXJzaW9uIGFuZCBzdHJpY3QgQ29uZmln
IFBhZ2Ugc2l6ZSB2YWxpZGF0aW9uLCBidXQgb24gdGhlaXIgb3duIHRoZXkgZG8gbm90IHlldCBw
cm92ZSBhIHJlYWwgb3ZlcnJ1biBvZiB0aGUgYWxsb2NhdGlvbi4K
--0000000000009463620657d8c0dd--
