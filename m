From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH v2 07/12] scsi/NCR5380: adopt NCR5380_dprint() and NCR5380_dprint_phase()
Date: Sat, 26 Apr 2014 13:51:28 +1200
Message-ID: <535B1120.1020700@gmail.com>
References: <20140319123516.542623278@telegraphics.com.au> <20140319123518.642821564@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20140319123518.642821564@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Acked-by: Michael Schmitz <schmitz@debian.org>

> All NCR5380 drivers already include the NCR5380.h header. Better to
> adopt those macros rather than have three variations on them.
>
> Moreover, the macros in NCR5380.h are preferable anyway: the atari_NCR5380
> and sun3_NCR5380 versions are inflexible. For example, they can't accomodate
> NCR5380_dprint(NDEBUG_MAIN | NDEBUG_QUEUES, ...)
>
> Replace the NCR_PRINT* macros from atari_NCR5380.h and sun3_NCR5380.h with
> the equivalent macros from NCR5380.h.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/atari_NCR5380.c |   22 +++++++++++-----------
>   drivers/scsi/sun3_NCR5380.c  |   22 +++++++++++-----------
>   2 files changed, 22 insertions(+), 22 deletions(-)
>
> Index: linux-m68k/drivers/scsi/atari_NCR5380.c
> ===================================================================
> --- linux-m68k.orig/drivers/scsi/atari_NCR5380.c	2014-03-19 23:23:02.000000000 +1100
> +++ linux-m68k/drivers/scsi/atari_NCR5380.c	2014-03-19 23:34:43.000000000 +1100
> @@ -739,8 +739,8 @@ static void NCR5380_print_status(struct
>   	Scsi_Cmnd *ptr;
>   	unsigned long flags;
>   
> -	NCR_PRINT(NDEBUG_ANY);
> -	NCR_PRINT_PHASE(NDEBUG_ANY);
> +	NCR5380_dprint(NDEBUG_ANY, instance);
> +	NCR5380_dprint_phase(NDEBUG_ANY, instance);
>   
>   	hostdata = (struct NCR5380_hostdata *)instance->hostdata;
>   
> @@ -1268,7 +1268,7 @@ static irqreturn_t NCR5380_intr(int irq,
>   	INT_PRINTK("scsi%d: BASR=%02x\n", HOSTNO, basr);
>   	/* dispatch to appropriate routine if found and done=0 */
>   	if (basr & BASR_IRQ) {
> -		NCR_PRINT(NDEBUG_INTR);
> +		NCR5380_dprint(NDEBUG_INTR, instance);
>   		if ((NCR5380_read(STATUS_REG) & (SR_SEL|SR_IO)) == (SR_SEL|SR_IO)) {
>   			done = 0;
>   			ENABLE_IRQ();
> @@ -1396,7 +1396,7 @@ static int NCR5380_select(struct Scsi_Ho
>   	unsigned long flags;
>   
>   	hostdata->restart_select = 0;
> -	NCR_PRINT(NDEBUG_ARBITRATION);
> +	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
>   	ARB_PRINTK("scsi%d: starting arbitration, id = %d\n", HOSTNO,
>   		   instance->this_id);
>   
> @@ -1617,7 +1617,7 @@ static int NCR5380_select(struct Scsi_Ho
>   			printk(KERN_ERR "scsi%d: weirdness\n", HOSTNO);
>   			if (hostdata->restart_select)
>   				printk(KERN_NOTICE "\trestart select\n");
> -			NCR_PRINT(NDEBUG_ANY);
> +			NCR5380_dprint(NDEBUG_ANY, instance);
>   			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
>   			return -1;
>   		}
> @@ -1742,7 +1742,7 @@ static int NCR5380_transfer_pio(struct S
>   		/* Check for phase mismatch */
>   		if ((tmp & PHASE_MASK) != p) {
>   			PIO_PRINTK("scsi%d: phase mismatch\n", HOSTNO);
> -			NCR_PRINT_PHASE(NDEBUG_PIO);
> +			NCR5380_dprint_phase(NDEBUG_PIO, instance);
>   			break;
>   		}
>   
> @@ -1764,18 +1764,18 @@ static int NCR5380_transfer_pio(struct S
>   		if (!(p & SR_IO)) {
>   			if (!((p & SR_MSG) && c > 1)) {
>   				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_DATA);
> -				NCR_PRINT(NDEBUG_PIO);
> +				NCR5380_dprint(NDEBUG_PIO, instance);
>   				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
>   					      ICR_ASSERT_DATA | ICR_ASSERT_ACK);
>   			} else {
>   				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
>   					      ICR_ASSERT_DATA | ICR_ASSERT_ATN);
> -				NCR_PRINT(NDEBUG_PIO);
> +				NCR5380_dprint(NDEBUG_PIO, instance);
>   				NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
>   					      ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
>   			}
>   		} else {
> -			NCR_PRINT(NDEBUG_PIO);
> +			NCR5380_dprint(NDEBUG_PIO, instance);
>   			NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ACK);
>   		}
>   
> @@ -1997,7 +1997,7 @@ static void NCR5380_information_transfer
>   			phase = (tmp & PHASE_MASK);
>   			if (phase != old_phase) {
>   				old_phase = phase;
> -				NCR_PRINT_PHASE(NDEBUG_INFORMATION);
> +				NCR5380_dprint_phase(NDEBUG_INFORMATION, instance);
>   			}
>   
>   			if (sink && (phase != PHASE_MSGOUT)) {
> @@ -2451,7 +2451,7 @@ static void NCR5380_information_transfer
>   				break;
>   			default:
>   				printk("scsi%d: unknown phase\n", HOSTNO);
> -				NCR_PRINT(NDEBUG_ANY);
> +				NCR5380_dprint(NDEBUG_ANY, instance);
>   			} /* switch(phase) */
>   		} /* if (tmp * SR_REQ) */
>   	} /* while (1) */
> Index: linux-m68k/drivers/scsi/sun3_NCR5380.c
> ===================================================================
> --- linux-m68k.orig/drivers/scsi/sun3_NCR5380.c	2014-03-19 23:34:42.000000000 +1100
> +++ linux-m68k/drivers/scsi/sun3_NCR5380.c	2014-03-19 23:34:43.000000000 +1100
> @@ -681,8 +681,8 @@ static void NCR5380_print_status(struct
>   	Scsi_Cmnd *ptr;
>   	unsigned long flags;
>   
> -	NCR_PRINT(NDEBUG_ANY);
> -	NCR_PRINT_PHASE(NDEBUG_ANY);
> +	NCR5380_dprint(NDEBUG_ANY, instance);
> +	NCR5380_dprint_phase(NDEBUG_ANY, instance);
>   
>   	hostdata = (struct NCR5380_hostdata *)instance->hostdata;
>   
> @@ -1192,7 +1192,7 @@ static irqreturn_t NCR5380_intr (int irq
>       INT_PRINTK("scsi%d: BASR=%02x\n", HOSTNO, basr);
>       /* dispatch to appropriate routine if found and done=0 */
>       if (basr & BASR_IRQ) {
> -	NCR_PRINT(NDEBUG_INTR);
> +	NCR5380_dprint(NDEBUG_INTR, instance);
>   	if ((NCR5380_read(STATUS_REG) & (SR_SEL|SR_IO)) == (SR_SEL|SR_IO)) {
>   	    done = 0;
>   //	    ENABLE_IRQ();
> @@ -1334,7 +1334,7 @@ static int NCR5380_select(struct Scsi_Ho
>       unsigned long flags;
>   
>       hostdata->restart_select = 0;
> -    NCR_PRINT(NDEBUG_ARBITRATION);
> +    NCR5380_dprint(NDEBUG_ARBITRATION, instance);
>       ARB_PRINTK("scsi%d: starting arbitration, id = %d\n", HOSTNO,
>   	       instance->this_id);
>   
> @@ -1555,7 +1555,7 @@ static int NCR5380_select(struct Scsi_Ho
>   	    printk(KERN_ERR "scsi%d: weirdness\n", HOSTNO);
>   	    if (hostdata->restart_select)
>   		printk(KERN_NOTICE "\trestart select\n");
> -	    NCR_PRINT(NDEBUG_ANY);
> +	    NCR5380_dprint(NDEBUG_ANY, instance);
>   	    NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
>   	    return -1;
>   	}
> @@ -1681,7 +1681,7 @@ static int NCR5380_transfer_pio( struct
>   	/* Check for phase mismatch */	
>   	if ((tmp & PHASE_MASK) != p) {
>   	    PIO_PRINTK("scsi%d: phase mismatch\n", HOSTNO);
> -	    NCR_PRINT_PHASE(NDEBUG_PIO);
> +	    NCR5380_dprint_phase(NDEBUG_PIO, instance);
>   	    break;
>   	}
>   
> @@ -1704,18 +1704,18 @@ static int NCR5380_transfer_pio( struct
>   	    if (!((p & SR_MSG) && c > 1)) {
>   		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
>   		    ICR_ASSERT_DATA);
> -		NCR_PRINT(NDEBUG_PIO);
> +		NCR5380_dprint(NDEBUG_PIO, instance);
>   		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
>   			ICR_ASSERT_DATA | ICR_ASSERT_ACK);
>   	    } else {
>   		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
>   		    ICR_ASSERT_DATA | ICR_ASSERT_ATN);
> -		NCR_PRINT(NDEBUG_PIO);
> +		NCR5380_dprint(NDEBUG_PIO, instance);
>   		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE |
>   		    ICR_ASSERT_DATA | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
>   	    }
>   	} else {
> -	    NCR_PRINT(NDEBUG_PIO);
> +	    NCR5380_dprint(NDEBUG_PIO, instance);
>   	    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ACK);
>   	}
>   
> @@ -1927,7 +1927,7 @@ static void NCR5380_information_transfer
>   	    phase = (tmp & PHASE_MASK);
>    	    if (phase != old_phase) {
>   		old_phase = phase;
> -		NCR_PRINT_PHASE(NDEBUG_INFORMATION);
> +		NCR5380_dprint_phase(NDEBUG_INFORMATION, instance);
>   	    }
>   
>   	    if(phase == PHASE_CMDOUT) {
> @@ -2412,7 +2412,7 @@ static void NCR5380_information_transfer
>   		break;
>   	    default:
>   		printk("scsi%d: unknown phase\n", HOSTNO);
> -		NCR_PRINT(NDEBUG_ANY);
> +		NCR5380_dprint(NDEBUG_ANY, instance);
>   	    } /* switch(phase) */
>   	} /* if (tmp * SR_REQ) */
>       } /* while (1) */
>
