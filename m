From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: FICON target support
Date: Thu, 30 May 2019 16:10:14 -0700
Message-ID: <5c5609d8-e4b4-3561-ece9-93746fd46206@acm.org>
References: <CADiuDASOCJbnwLs-LEp0aCX+T4dMvFfKQv_zsypHW-iSF8wW=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <CADiuDASOCJbnwLs-LEp0aCX+T4dMvFfKQv_zsypHW-iSF8wW=Q@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Christian Svensson <christian-IHD7e6/dsE0@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 5/26/19 8:51 AM, Christian Svensson wrote:
> I am doing some preliminary scouting of how one could add support for
> FICON (FC-SB-3 specifically). I am mostly interested in Linux being
> able to act as a FICON target for now.
> 
> The TL;DR summary for FICON is that it uses Fibre Channel just like FCP/SCSI
> up to but not including the FC-4 (FCP) layer. At that point it uses its own
> SBCCS layer.
> 
> FICON is used by IBM mainframes to interface peripherals like tape, disk,
> printers, card punchers/readers, etc. It is more like a mainframe USB/Firewire
> than SCSI in that regard.
> 
> I would prefer to implement my peripherals in user-space, I don't see any
> convincing case for having e.g. a virtual tape drive running in kernel space.
> The I/O heavy disks would probably benefit from being in kernel space, but I am
> OK limiting the initial scope.
> 
> I am 100% new to the SCSI and Fibre Channel subsystem in Linux, and I
> do not even know if the current HBAs support sending frames without FCP
> but after scouting the code it does seem that it might work out - FCP
> seems decoupled enough.
> 
> If you want to learn more the standard document Wireshark has an
> implementation of the protocol (packet-fcsb3.c/h). If you want all the details
> you will sadly have to pay $60 and buy it from INCITS at
> https://webstore.ansi.org/Standards/INCITS/INCITS3742003S2013.
> Fwiw, FICON uses FC type 0x1B and 0x1C.
> 
> Any thoughts or ideas where you would start? Do you see any future for this
> addition to the kernel?

Hi Chris,

I'm not sure what the best approach is for the initiator functionality. 
For the target functionality you may want to have a look at tcmu 
(Documentation/target/tcmu-design.txt and 
drivers/target/target_core_user.c). An existing FC target driver is 
available in drivers/scsi/qla2xxx/tcm_qla2xxx.c. A diagram that shows 
the different functional blocks in TCM is available at 
https://en.wikipedia.org/wiki/LIO_(SCSI_target) (LIO is another name for 
TCM).

Bart.
