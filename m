From: Fabien Salvi <fabien@cri74.org>
Subject: qlogicfc // qla2x00 parameters and failover
Date: Thu, 30 May 2002 16:19:32 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CF634F4.E66E8193@cri74.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: Lorraine Suschetet <lorraine@ext.cri74.org>

Hello, 


We have Qlogic 2200 HBAs with a Vixel 2100 hub and a storage
enclosure with 2 CMD 7240 controllers (redundant in active/active mode).

We have tried to use both qlogicfc and qla2x00 drivers to see the better
driver to use.

There are different versions of the qla2x00 driver developped by Qlogic,
some are available on qlogic website
(http://www.qlogic.com/support/product_resources.asp?id=113) and others
elsewhere, for example on the IBM website
(http://www.pc.ibm.com/qtechinfo/MIGR-42081.html).


=== drivers parameters ===


In the qlogicfc, Lorraine has increased the "QLOGICFC_REQ_QUEUE_LEN"
(see the FibreChannel howto :
http://tech.sistina.com/gfs/howtos/fibrechannel_howto/node7.html)
because of problems when under heavy load (lot of IO/s).

It seems not necessary to do it in qlogic driver, the default value
should be high enough...
I suppose this is this parameter in qla2x00.h :
/* Maximum outstanding commands in ISP queues (1-65535) */
#define MAX_OUTSTANDING_COMMANDS   1024



However, in the qla2x00 driver, we can found these parameters in
qla2x00.h (for example with IBM certified v5.38.6) :

/*
 * Fibre Channel device definitions.
 */
#define WWN_SIZE                8       /* Size of WWPN, WWN & WWNN */
#define MAX_FIBRE_DEVICES       256
#define MAX_FIBRE_LUNS          256
#define MAX_RSCN_COUNT          10
#define MAX_HOST_COUNT          8

/*
 * Host adapter default definitions.
 */
#define MAX_BUSES            1  /* We only have one bus today */
#define MAX_TARGETS_2100     MAX_FIBRE_DEVICES
#define MAX_TARGETS_2200     MAX_FIBRE_DEVICES
#define MAX_TARGETS          MAX_FIBRE_DEVICES
#define MAX_LUNS             MAX_FIBRE_LUNS
#define MAX_CMDS_PER_LUN     255 


Should we change these parameters according to our controllers specs ?
In CMD technical documentation, they say that for Queue Depth,
controllers supports up to 64 commands per lun.
Should we modify MAX_CMDS_PER_LUN to 64 instead of 255 ?
Is there any other tuning to do ?


Also, we have the same in qlogicfc driver (qlogicfc.h) :
#define QLOGICFC_CMD_PER_LUN    8



=== Failover ===

We plan to use the qla2x00 instead of the qlogicfc to use failover
capabilities of these HBAs.
We would like to use a switch (for example the Qlogic SANbox2) for the
active mode and 2 cascaded hubs for the passive mode.
Do you think we could have problems with this architecture ?
In fact, we would have the active primary HBA what will use Fabric Login
and the passive secondary HBA what will use classic LIP.

In your mind, is this something acceptable ?


=== 1 Gbits/s <==> 2 Gbits/s ===

Finally, another question (a little off topic, sorry...):
Does some people have encountered problems mixing 1 and 2Gbits/s
elements ?
For example, now, 2 Gbits/s Qlogic switches are cheaper than 1Gbit/s !
I would like to have a 2Gbit/s switch with a mix of 1 or 2 Gbits/s HBAs
(qla2200 and qla2300) and 1 Gbit/s link to our storage controllers...
But, I'm afraid we can't mix 2 sort of card in failover configuration,
isn't it ?


Well, that's a lot of questions, I apologize...
Thanks in advance for your help !


B.R.

-------------
Fabien SALVI      Centre de Ressources Informatiques
                  Archamps, France -- http://www.cri74.org
                  PingOO GNU/linux distribution : http://www.pingoo.org
