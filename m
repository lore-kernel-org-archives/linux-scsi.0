From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Thu, 29 Aug 2013 19:34:50 +0000
Message-ID: <bug-60644-11613-3gj18kBsQn@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59738 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab3H2TfA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Aug 2013 15:35:00 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7F8302056E
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2013 19:34:58 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 2BAF120595
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2013 19:34:53 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #29 from liveaxle@live.com ---
Hi .

I created a BTRFS RAID0 using a leafsize of 64k .

Copying some files to the RAID results in some strange output in dmesg :

[107991.481826] sd 8:0:10:0: [sdm]
[107991.482239] Sense Key : 0x2 [current]
[107991.482657] sd 8:0:10:0: [sdm]
[107991.483067] ASC=0x4 ASCQ=0x0
[107991.483475] sd 8:0:10:0: [sdm] CDB:
[107991.483885] cdb[0]=0x2a: 2a 00 00 3a 0b 80 00 04 00 00
[107991.484337] sd 8:0:10:0: [sdm] Device not ready
[107991.484752] sd 8:0:10:0: [sdm]
[107991.485163] Result: hostbyte=0x00 driverbyte=0x08
[107991.485581] sd 8:0:10:0: [sdm]
[107991.486001] Sense Key : 0x2 [current]
[107991.486441] sd 8:0:10:0: [sdm]
[107991.486856] ASC=0x4 ASCQ=0x0
[107991.487260] sd 8:0:10:0: [sdm] CDB:
[107991.487659] cdb[0]=0x2a: 2a 00 00 3a 0f 80 00 04 00 00
[107991.488100] sd 8:0:10:0: [sdm] Device not ready
[107991.488510] sd 8:0:10:0: [sdm]
[107991.488915] Result: hostbyte=0x00 driverbyte=0x08
[107991.489321] sd 8:0:10:0: [sdm]
[107991.489715] Sense Key : 0x2 [current]
[107991.490108] sd 8:0:10:0: [sdm]
[107991.490495] ASC=0x4 ASCQ=0x0
[107991.490882] sd 8:0:10:0: [sdm] CDB:
[107991.491269] cdb[0]=0x2a: 2a 00 00 3a 13 80 00 04 00 00
[107991.491704] sd 8:0:10:0: [sdm] Device not ready
[107991.492103] sd 8:0:10:0: [sdm]
[107991.492491] Result: hostbyte=0x00 driverbyte=0x08
[107991.492882] sd 8:0:10:0: [sdm]
[107991.493291] Sense Key : 0x2 [current]
[107991.493684] sd 8:0:10:0: [sdm]
[107991.494070] ASC=0x4 ASCQ=0x0
[107991.494454] sd 8:0:10:0: [sdm] CDB:
[107991.494838] cdb[0]=0x2a: 2a 00 00 3a 17 80 00 04 00 00
[107991.495272] sd 8:0:10:0: [sdm] Device not ready
[107991.495669] sd 8:0:10:0: [sdm]
[107991.496057] Result: hostbyte=0x00 driverbyte=0x08
[107991.496446] sd 8:0:10:0: [sdm]
[107991.496835] Sense Key : 0x2 [current]
[107991.497227] sd 8:0:10:0: [sdm]
[107991.497612] ASC=0x4 ASCQ=0x0
[107991.497996] sd 8:0:10:0: [sdm] CDB:
[107991.498379] cdb[0]=0x2a: 2a 00 00 3a 1b 80 00 04 00 00
[107991.498810] sd 8:0:10:0: [sdm] Device not ready
[107991.499207] sd 8:0:10:0: [sdm]
[107991.499593] Result: hostbyte=0x00 driverbyte=0x08
[107991.500018] sd 8:0:10:0: [sdm]
[107991.500407] Sense Key : 0x2 [current]
[107991.500797] sd 8:0:10:0: [sdm]
[107991.501182] ASC=0x4 ASCQ=0x0
[107991.501567] sd 8:0:10:0: [sdm] CDB:
[107991.501951] cdb[0]=0x2a: 2a 00 00 3a 1f 80 00 04 00 00
[107991.502385] sd 8:0:10:0: [sdm] Device not ready
[107991.502782] sd 8:0:10:0: [sdm]
[107991.503170] Result: hostbyte=0x00 driverbyte=0x08
[107991.503558] sd 8:0:10:0: [sdm]
[107991.503948] Sense Key : 0x2 [current]
[107991.504338] sd 8:0:10:0: [sdm]
[107991.504723] ASC=0x4 ASCQ=0x0
[107991.505108] sd 8:0:10:0: [sdm] CDB:
[107991.505493] cdb[0]=0x2a: 2a 00 00 3a 23 80 00 04 00 00
[107991.505927] sd 8:0:10:0: [sdm] Device not ready
[107991.506343] sd 8:0:10:0: [sdm]
[107991.506730] Result: hostbyte=0x00 driverbyte=0x08
[107991.507119] sd 8:0:10:0: [sdm]
[107991.507507] Sense Key : 0x2 [current]
[107991.507896] sd 8:0:10:0: [sdm]
[107991.508296] ASC=0x4 ASCQ=0x0
[107991.508678] sd 8:0:10:0: [sdm] CDB:
[107991.509059] cdb[0]=0x2a: 2a 00 00 3a 27 80 00 04 00 00
[107991.509486] sd 8:0:10:0: [sdm] Device not ready
[107991.509881] sd 8:0:10:0: [sdm]
[107991.510267] Result: hostbyte=0x00 driverbyte=0x08
[107991.510655] sd 8:0:10:0: [sdm]
[107991.511043] Sense Key : 0x2 [current]
[107991.511430] sd 8:0:10:0: [sdm]
[107991.511815] ASC=0x4 ASCQ=0x0
[107991.512197] sd 8:0:10:0: [sdm] CDB:
[107991.512581] cdb[0]=0x2a: 2a 00 00 3a 2b 80 00 04 00 00
[107991.513044] sd 8:0:10:0: [sdm] Device not ready
[107991.513440] sd 8:0:10:0: [sdm]
[107991.513826] Result: hostbyte=0x00 driverbyte=0x08
[107991.514214] sd 8:0:10:0: [sdm]
[107991.514603] Sense Key : 0x2 [current]
[107991.514994] sd 8:0:10:0: [sdm]
[107991.515377] ASC=0x4 ASCQ=0x0
[107991.515760] sd 8:0:10:0: [sdm] CDB:
[107991.516144] cdb[0]=0x2a: 2a 00 00 3a 2f 80 00 04 00 00
[107991.516576] sd 8:0:10:0: [sdm] Device not ready
[107991.516973] sd 8:0:10:0: [sdm]
[107991.517360] Result: hostbyte=0x00 driverbyte=0x08
[107991.517749] sd 8:0:10:0: [sdm]
[107991.518138] Sense Key : 0x2 [current]
[107991.518527] sd 8:0:10:0: [sdm]
[107991.518911] ASC=0x4 ASCQ=0x0
[107991.519295] sd 8:0:10:0: [sdm] CDB:
[107991.519696] cdb[0]=0x2a: 2a 00 00 3a 33 80 00 04 00 00
[107991.520129] sd 8:0:10:0: [sdm] Device not ready
[107991.520528] sd 8:0:10:0: [sdm]
[107991.520915] Result: hostbyte=0x00 driverbyte=0x08
[107991.521305] sd 8:0:10:0: [sdm]
[107991.521695] Sense Key : 0x2 [current]
[107991.522087] sd 8:0:10:0: [sdm]
[107991.522472] ASC=0x4 ASCQ=0x0
[107991.522856] sd 8:0:10:0: [sdm] CDB:
[107991.523241] cdb[0]=0x2a: 2a 00 00 3a 37 80 00 04 00 00
[107991.523675] sd 8:0:10:0: [sdm] Device not ready
[107991.524073] sd 8:0:10:0: [sdm]
[107991.524460] Result: hostbyte=0x00 driverbyte=0x08
[107991.524850] sd 8:0:10:0: [sdm]
[107991.525241] Sense Key : 0x2 [current]
[107991.525631] sd 8:0:10:0: [sdm]
[107991.526018] ASC=0x4 ASCQ=0x0
[107991.526437] sd 8:0:10:0: [sdm] CDB:
[107991.526823] cdb[0]=0x2a: 2a 00 00 3a 3b 80 00 04 00 00
[107991.527257] sd 8:0:10:0: [sdm] Device not ready
[107991.527657] sd 8:0:10:0: [sdm]
[107991.528047] Result: hostbyte=0x00 driverbyte=0x08
[107991.528437] sd 8:0:10:0: [sdm]
[107991.528829] Sense Key : 0x2 [current]
[107991.529221] sd 8:0:10:0: [sdm]
[107991.529609] ASC=0x4 ASCQ=0x0
[107991.529996] sd 8:0:10:0: [sdm] CDB:
[107991.530382] cdb[0]=0x2a: 2a 00 00 3a 3f 80 00 04 00 00
[107991.530816] sd 8:0:10:0: [sdm] Device not ready
[107991.531216] sd 8:0:10:0: [sdm]
[107991.531604] Result: hostbyte=0x00 driverbyte=0x08
[107991.531996] sd 8:0:10:0: [sdm]
[107991.532387] Sense Key : 0x2 [current]
[107991.532780] sd 8:0:10:0: [sdm]
[107991.533184] ASC=0x4 ASCQ=0x0
[107991.533571] sd 8:0:10:0: [sdm] CDB:
[107991.533958] cdb[0]=0x2a: 2a 00 00 3a 43 80 00 04 00 00
[107991.534392] sd 8:0:10:0: [sdm] Device not ready
[107991.534791] sd 8:0:10:0: [sdm]
[107991.535180] Result: hostbyte=0x00 driverbyte=0x08
[107991.535572] sd 8:0:10:0: [sdm]
[107991.535964] Sense Key : 0x2 [current]
[107991.536358] sd 8:0:10:0: [sdm]
[107991.536747] ASC=0x4 ASCQ=0x0
[107991.537134] sd 8:0:10:0: [sdm] CDB:
[107991.537520] cdb[0]=0x2a: 2a 00 00 3a 47 80 00 04 00 00
[107991.537956] sd 8:0:10:0: [sdm] Device not ready
[107991.538357] sd 8:0:10:0: [sdm]
[107991.538746] Result: hostbyte=0x00 driverbyte=0x08
[107991.539139] sd 8:0:10:0: [sdm]
[107991.539529] Sense Key : 0x2 [current]
[107991.539954] sd 8:0:10:0: [sdm]
[107991.540340] ASC=0x4 ASCQ=0x0
[107991.540726] sd 8:0:10:0: [sdm] CDB:
[107991.541112] cdb[0]=0x2a: 2a 00 00 3a 4b 80 00 04 00 00
[107991.541542] sd 8:0:10:0: [sdm] Device not ready
[107991.541941] sd 8:0:10:0: [sdm]
[107991.542330] Result: hostbyte=0x00 driverbyte=0x08
[107991.542720] sd 8:0:10:0: [sdm]
[107991.543113] Sense Key : 0x2 [current]
[107991.543507] sd 8:0:10:0: [sdm]
[107991.543894] ASC=0x4 ASCQ=0x0
[107991.544281] sd 8:0:10:0: [sdm] CDB:
[107991.544668] cdb[0]=0x2a: 2a 00 00 3a 4f 80 00 01 80 00
[107991.545090] sd 8:0:10:0: [sdm] Device not ready
[107991.545489] sd 8:0:10:0: [sdm]
[107991.545883] Result: hostbyte=0x00 driverbyte=0x08
[107991.546277] sd 8:0:10:0: [sdm]
[107991.546684] Sense Key : 0x2 [current]
[107991.547076] sd 8:0:10:0: [sdm]
[107991.547464] ASC=0x4 ASCQ=0x0
[107991.547848] sd 8:0:10:0: [sdm] CDB:
[107991.548234] cdb[0]=0x2a: 2a 00 00 21 38 00 00 04 00 00
[107991.548669] sd 8:0:10:0: [sdm] Device not ready
[107991.549083] sd 8:0:10:0: [sdm]
[107991.549470] Result: hostbyte=0x00 driverbyte=0x08
[107991.549861] sd 8:0:10:0: [sdm]
[107991.550252] Sense Key : 0x2 [current]
[107991.550642] sd 8:0:10:0: [sdm]
[107991.551029] ASC=0x4 ASCQ=0x0
[107991.551415] sd 8:0:10:0: [sdm] CDB:
[107991.551800] cdb[0]=0x2a: 2a 00 00 21 3c 00 00 04 00 00
[107991.552235] sd 8:0:10:0: [sdm] Device not ready
[107991.552649] sd 8:0:10:0: [sdm]
[107991.553054] Result: hostbyte=0x00 driverbyte=0x08
[107991.553444] sd 8:0:10:0: [sdm]
[107991.553835] Sense Key : 0x2 [current]
[107991.554225] sd 8:0:10:0: [sdm]
[107991.554610] ASC=0x4 ASCQ=0x0
[107991.554996] sd 8:0:10:0: [sdm] CDB:
[107991.555382] cdb[0]=0x2a: 2a 00 00 21 40 00 00 04 00 00
[107991.555817] sd 8:0:10:0: [sdm] Device not ready
[107991.556232] sd 8:0:10:0: [sdm]
[107991.556621] Result: hostbyte=0x00 driverbyte=0x08
[107991.557013] sd 8:0:10:0: [sdm]
[107991.557402] Sense Key : 0x2 [current]
[107991.557792] sd 8:0:10:0: [sdm]
[107991.558181] ASC=0x4 ASCQ=0x0
[107991.558564] sd 8:0:10:0: [sdm] CDB:
[107991.558949] cdb[0]=0x2a: 2a 00 00 21 44 00 00 04 00 00
[107991.559385] sd 8:0:10:0: [sdm] Device not ready
[107991.559811] sd 8:0:10:0: [sdm]
[107991.560199] Result: hostbyte=0x00 driverbyte=0x08
[107991.560588] sd 8:0:10:0: [sdm]
[107991.560976] Sense Key : 0x2 [current]
[107991.561367] sd 8:0:10:0: [sdm]
[107991.561750] ASC=0x4 ASCQ=0x0
[107991.562132] sd 8:0:10:0: [sdm] CDB:
[107991.562516] cdb[0]=0x2a: 2a 00 00 21 48 00 00 04 00 00
[107991.562949] sd 8:0:10:0: [sdm] Device not ready
[107991.563362] sd 8:0:10:0: [sdm]
[107991.563748] Result: hostbyte=0x00 driverbyte=0x08
[107991.564135] sd 8:0:10:0: [sdm]
[107991.564524] Sense Key : 0x2 [current]
[107991.564912] sd 8:0:10:0: [sdm]
[107991.565295] ASC=0x4 ASCQ=0x0
[107991.565676] sd 8:0:10:0: [sdm] CDB:
[107991.566058] cdb[0]=0x2a: 2a 00 00 21 4c 00 00 04 00 00
[107991.566523] sd 8:0:10:0: [sdm] Device not ready
[107991.566937] sd 8:0:10:0: [sdm]
[107991.567322] Result: hostbyte=0x00 driverbyte=0x08
[107991.567708] sd 8:0:10:0: [sdm]
[107991.568095] Sense Key : 0x2 [current]
[107991.568482] sd 8:0:10:0: [sdm]
[107991.568865] ASC=0x4 ASCQ=0x0
[107991.569246] sd 8:0:10:0: [sdm] CDB:
[107991.569628] cdb[0]=0x2a: 2a 00 00 21 50 00 00 04 00 00
[107991.570058] sd 8:0:10:0: [sdm] Device not ready
[107991.570469] sd 8:0:10:0: [sdm]
[107991.570855] Result: hostbyte=0x00 driverbyte=0x08
[107991.571244] sd 8:0:10:0: [sdm]
[107991.571632] Sense Key : 0x2 [current]
[107991.572020] sd 8:0:10:0: [sdm]
[107991.572402] ASC=0x4 ASCQ=0x0
[107991.572783] sd 8:0:10:0: [sdm] CDB:
[107991.573182] cdb[0]=0x2a: 2a 00 00 21 54 00 00 04 00 00
[107991.573612] sd 8:0:10:0: [sdm] Device not ready
[107991.574023] sd 8:0:10:0: [sdm]
[107991.574409] Result: hostbyte=0x00 driverbyte=0x08
[107991.574796] sd 8:0:10:0: [sdm]
[107991.575186] Sense Key : 0x2 [current]
[107991.575576] sd 8:0:10:0: [sdm]
[107991.575960] ASC=0x4 ASCQ=0x0
[107991.576345] sd 8:0:10:0: [sdm] CDB:
[107991.576729] cdb[0]=0x2a: 2a 00 00 21 58 00 00 04 00 00
[107991.577161] sd 8:0:10:0: [sdm] Device not ready
[107991.577572] sd 8:0:10:0: [sdm]
[107991.577959] Result: hostbyte=0x00 driverbyte=0x08
[107991.578348] sd 8:0:10:0: [sdm]
[107991.578736] Sense Key : 0x2 [current]
[107991.579125] sd 8:0:10:0: [sdm]
[107991.579509] ASC=0x4 ASCQ=0x0
[107991.579924] sd 8:0:10:0: [sdm] CDB:
[107991.580307] cdb[0]=0x2a: 2a 00 00 21 5c 00 00 04 00 00


The copying proccess does not stop , drives do not drop and the mountpoint
still intact . However , trying to read the copied files result in Input/Output
Error .

THank you .

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
