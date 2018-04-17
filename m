From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: Re: [RESEND PATCH v1 1/2] trace: events: scsi: Add tag in SCSI trace
 events
Date: Tue, 17 Apr 2018 10:00:23 +0000
Message-ID: <89ca9f7d20c24a3d9c743c7f5ca2d108@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "mingo@redhad.com" <mingo@redhad.com>, "rajatja@google.com" <rajatja@google.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hi, Steve 
Right, Please see below portion log from ftrace and blktrace,
There is no any impact on blktrace. 
>
>Looking at the code from
>git://git.kernel.org/pub/scm/linux/kernel/git/axboe/blktrace.git
>
>It appears that it does not rely on the ftrace ring buffers.
>
>So I'm guessing blktrace is not affected by this patch.
>
>-- Steve


#/blktrace -d /dev/block/sdd14 -o - | ./blkparse -i -  
  8,62   3     1162     0.213039583  4116  P   N [iozone]
  8,62   3     1163     0.213041146  4116  U   N [iozone] 1
  8,62   3     1164     0.213042708  4116  I  WS 39573632 + 128 [iozone]
  8,62   3     1165     0.213044791  4116  D  WS 39573632 + 128 [iozone]
  8,48   3     1166     0.213585416  4116  A  WS 39573760 + 128 <- (8,62) 342272
  8,62   3     1167     0.213590104  4116  Q  WS 39573760 + 128 [iozone]
  8,62   3     1168     0.213592187  4116  G  WS 39573760 + 128 [iozone]
  8,62   3     1169     0.213594271  4116  P   N [iozone]
  8,62   3     1170     0.213595833  4116  U   N [iozone] 1
  8,62   3     1171     0.213597396  4116  I  WS 39573760 + 128 [iozone]
  8,62   3     1172     0.213600000  4116  D  WS 39573760 + 128 [iozone]
  8,48   3     1173     0.214092187  4116  A  WS 39573888 + 128 <- (8,62) 342400
  8,62   3     1174     0.214094791  4116  Q  WS 39573888 + 128 [iozone]
  8,62   3     1175     0.214097916  4116  G  WS 39573888 + 128 [iozone]
  8,62   3     1176     0.214102604  4116  P   N [iozone]
  8,62   3     1177     0.214105208  4116  U   N [iozone] 1
  8,62   3     1178     0.214106771  4116  I  WS 39573888 + 128 [iozone]
  8,62   3     1179     0.214111458  4116  D  WS 39573888 + 128 [iozone]
  8,48   3     1180     0.216531771  4115  A  WS 39546496 + 128 <- (8,62) 315008
  8,62   3     1181     0.216534896  4115  Q  WS 39546496 + 128 [iozone]
  8,62   3     1182     0.216538021  4115  G  WS 39546496 + 128 [iozone]
  8,62   3     1183     0.216540625  4115  P   N [iozone]
  8,62   3     1184     0.216543229  4115  U   N [iozone] 1
  8,62   3     1185     0.216544791  4115  I  WS 39546496 + 128 [iozone]
  8,62   3     1186     0.216547396  4115  D  WS 39546496 + 128 [iozone]
  8,48   3     1187     0.217146354  4115  A  WS 39546624 + 128 <- (8,62) 315136
  8,62   3     1188     0.217148437  4115  Q  WS 39546624 + 128 [iozone]
  8,62   3     1189     0.217151041  4115  G  WS 39546624 + 128 [iozone]
  8,62   3     1190     0.217153646  4115  P   N [iozone]
  8,62   3     1191     0.217155208  4115  U   N [iozone] 1
  8,62   3     1192     0.217156771  4115  I  WS 39546624 + 128 [iozone]
  8,62   3     1193     0.217159896  4115  D  WS 39546624 + 128 [iozone]
  8,48   3     1194     0.217712500  4115  A  WS 39546752 + 128 <- (8,62) 315264
  8,62   3     1195     0.217714583  4115  Q  WS 39546752 + 128 [iozone]
  8,62   3     1196     0.217717708  4115  G  WS 39546752 + 128 [iozone]
  8,62   3     1197     0.217722396  4115  P   N [iozone]
  8,62   3     1198     0.217724479  4115  U   N [iozone] 1
  8,62   3     1199     0.217726041  4115  I  WS 39546752 + 128 [iozone]
  8,62   3     1200     0.217728646  4115  D  WS 39546752 + 128 [iozone]
  8,62   5     1150     0.198047916     0  C  WS 39569920 + 128 [0]
  8,62   4     1104     0.198104687     0  C  WS 39576448 + 128 [0]
  8,48   5     1151     0.198182291  4116  A  WS 39570048 + 128 <- (8,62) 338560
  8,62   5     1152     0.198183333  4116  Q  WS 39570048 + 128 [iozone]
  8,62   5     1153     0.198184375  4116  G  WS 39570048 + 128 [iozone]
  8,62   5     1154     0.198185937  4116  P   N [iozone]
  8,62   5     1155     0.198186458  4116  U   N [iozone] 1
  8,62   5     1156     0.198186979  4116  I  WS 39570048 + 128 [iozone]
  8,62   5     1157     0.198188541  4116  D  WS 39570048 + 128 [iozone]
  8,48   4     1105     0.198218229  4114  A  WS 39576576 + 128 <- (8,62) 345088
  8,62   4     1106     0.198219271  4114  Q  WS 39576576 + 128 [iozone]
  8,62   4     1107     0.198220312  4114  G  WS 39576576 + 128 [iozone]
  8,62   4     1108     0.198221354  4114  P   N [iozone]
  8,62   4     1109     0.198221875  4114  U   N [iozone] 1
  8,62   4     1110     0.198222396  4114  I  WS 39576576 + 128 [iozone]
  8,62   4     1111     0.198223437  4114  D  WS 39576576 + 128 [iozone]
  8,62   4     1112     0.198245312  4114  C  WS 39594368 + 128 [0]
  8,62   5     1158     0.198336979     0  C  WS 39570048 + 128 [0]
  8,62   4     1113     0.198409375     0  C  WS 39576576 + 128 [0]
  8,48   5     1159     0.199219791  4113  A  WS 39594624 + 128 <- (8,62) 363136
  8,62   5     1160     0.199220833  4113  Q  WS 39594624 + 128 [iozone]
  8,62   5     1161     0.199222396  4113  G  WS 39594624 + 128 [iozone]
  8,62   5     1162     0.199223437  4113  P   N [iozone]
  8,62   5     1163     0.199224479  4113  U   N [iozone] 1
  8,62   5     1164     0.199225000  4113  I  WS 39594624 + 128 [iozone]
  8,62   5     1165     0.199226562  4113  D  WS 39594624 + 128 [iozone]
  8,48   4     1114     0.199235937  4116  A  WS 39570176 + 128 <- (8,62) 338688
  8,62   4     1115     0.199236979  4116  Q  WS 39570176 + 128 [iozone]
  8,62   4     1116     0.199238021  4116  G  WS 39570176 + 128 [iozone]
  8,62   4     1117     0.199239062  4116  P   N [iozone]
  8,62   4     1118     0.199239583  4116  U   N [iozone] 1
  8,62   4     1119     0.199240104  4116  I  WS 39570176 + 128 [iozone]
  8,62   4     1120     0.199241666  4116  D  WS 39570176 + 128 [iozone]
  8,62   4     1121     0.199404687     0  C  WS 39570176 + 128 [0]
  8,62   5     1166     0.199467187     0  C  WS 39594624 + 128 [0]
  8,48   5     1167     0.199960416  4113  A  WS 39594752 + 128 <- (8,62) 363264
  8,62   5     1168     0.199960937  4113  Q  WS 39594752 + 128 [iozone]
  8,62   5     1169     0.199961979  4113  G  WS 39594752 + 128 [iozone]
  8,62   5     1170     0.199963541  4113  P   N [iozone]
  8,62   5     1171     0.199964062  4113  U   N [iozone] 1
  8,62   5     1172     0.199964583  4113  I  WS 39594752 + 128 [iozone]
  8,62   5     1173     0.199966146  4113  D  WS 39594752 + 128 [iozone]
  8,48   4     1122     0.199970833  4116  A  WS 39570304 + 128 <- (8,62) 338816
  8,62   4     1123     0.199971875  4116  Q  WS 39570304 + 128 [iozone]
  8,62   4     1124     0.199972916  4116  G  WS 39570304 + 128 [iozone]
  8,62   4     1125     0.199973958  4116  P   N [iozone]
  8,62   4     1126     0.199974479  4116  U   N [iozone] 1

#Cat trace
iozone-4055  [000] ....   665.039276: block_unplug: [iozone] 1 Sync
iozone-4055  [000] ...1   665.039278: block_rq_insert: 8,48 WS 0 () 39604352 + 128 tag=18 [iozone]
iozone-4055  [000] ...1   665.039280: block_rq_issue: 8,48 WS 0 () 39604352 + 128 tag=18 [iozone]
iozone-4055  [000] ...1   665.039284: scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=3 data_sgl=16 prot_sgl=0 prot_op=SCSI_PROT_NORMAL tag=18 cmnd=(WRITE_10 lba=4950544 txlen=16 protect=0 raw=2a 00 00 4b 8a 10 00 00 10 00)
iozone-4056  [002] ....   665.039284: block_dirty_buffer: 8,62 sector=44375 size=4096
<idle>-0     [000] d.h2   665.039319: scsi_dispatch_cmd_done: host_no=0 channel=0 id=0 lun=3 data_sgl=16 prot_sgl=0 prot_op=SCSI_PROT_NORMAL tag=24 cmnd=(WRITE_10 lba=4944016 txlen=16 protect=0 raw=2a 00 00 4b 70 90 00 00 10 00) result=(driver=DRIVER_OK host=DID_OK message=COMMAND_COMPLETE status=SAM_STAT_GOOD)
<idle>-0     [000] d.h3   665.039321: block_rq_complete: 8,48 WS () 39552128 + 128 tag=24 [0]
iozone-4056  [002] ....   665.039325: block_dirty_buffer: 8,62 sector=44380 size=4096
iozone-4058  [003] ....   665.039362: block_bio_remap: 8,48 WS 39568768 + 128 <- (8,62) 337280
iozone-4058  [003] ....   665.039364: block_bio_queue: 8,48 WS 39568768 + 128 [iozone]
iozone-4058  [003] ...1   665.039366: block_getrq: 8,48 WS 39568768 + 128 [iozone]
iozone-4058  [003] ...1   665.039368: block_plug: [iozone]
iozone-4058  [003] ....   665.039369: block_unplug: [iozone] 1 Sync
iozone-4058  [003] ...1   665.039371: block_rq_insert: 8,48 WS 0 () 39568768 + 128 tag=16 [iozone]
iozone-4058  [003] ...1   665.039373: block_rq_issue: 8,48 WS 0 () 39568768 + 128 tag=16 [iozone]
iozone-4058  [003] ...1   665.039375: scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=3 data_sgl=16 prot_sgl=0 prot_op=SCSI_PROT_NORMAL tag=16 cmnd=(WRITE_10 lba=4946096 txlen=16 protect=0 raw=2a 00 00 4b 78 b0 00 00 10 00)
iozone-4057  [001] ....   665.039402: block_touch_buffer: 8,62 sector=1034 size=4096
<idle>-0     [000] d.h2   665.039410: scsi_dispatch_cmd_done: host_no=0 channel=0 id=0 lun=3 data_sgl=16 prot_sgl=0 prot_op=SCSI_PROT_NORMAL tag=18 cmnd=(WRITE_10 lba=4950544 txlen=16 protect=0 raw=2a 00 00 4b 8a 10 00 00 10 00) result=(driver=DRIVER_OK host=DID_OK message=COMMAND_COMPLETE status=SAM_STAT_GOOD)
<idle>-0     [000] d.h3   665.039412: block_rq_complete: 8,48 WS () 39604352 + 128 tag=18 [0]
iozone-4057  [001] ....   665.039415: block_dirty_buffer: 8,62 sector=40096 size=4096
iozone-4056  [002] ....   665.039425: block_bio_remap: 8,48 WS 39586432 + 128 <- (8,62) 354944
iozone-4056  [002] ....   665.039427: block_bio_queue: 8,48 WS 39586432 + 128 [iozone]
iozone-4057  [001] ....   665.039427: block_dirty_buffer: 8,62 sector=40097 size=4096
iozone-4056  [002] ...1   665.039430: block_getrq: 8,48 WS 39586432 + 128 [iozone]
iozone-4056  [002] ...1   665.039432: block_plug: [iozone]
iozone-4056  [002] ....   665.039434: block_unplug: [iozone] 1 Sync
iozone-4056  [002] ...1   665.039435: block_rq_insert: 8,48 WS 0 () 39586432 + 128 tag=30 [iozone]
iozone-4057  [001] ....   665.039437: block_dirty_buffer: 8,62 sector=40098 size=4096
iozone-4056  [002] ...1   665.039437: block_rq_issue: 8,48 WS 0 () 39586432 + 128 tag=30 [iozone]
iozone-4056  [002] ...1   665.039439: scsi_dispatch_cmd_start: host_no=0 channel=0 id=0 lun=3 data_sgl=16 prot_sgl=0 prot_op=SCSI_PROT_NORMAL tag=30 cmnd=(WRITE_10 lba=4948304 txlen=16 protect=0 raw=2a 00 00 4b 81 50 00 00 10 00)

Especially, the ftrace log with tag information, I can easily figure out one I/O request between block layer and SCSI.

//Bean Huo
