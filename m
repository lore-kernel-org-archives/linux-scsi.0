From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH/RFC 2/2] 3ware 9000 SATA-RAID driver v2.26.00.009
Date: Wed, 26 May 2004 17:16:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B50931.6050002@pobox.com>
References: <HYC9VV01.E0R@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:51372 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265809AbUEZVQt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 17:16:49 -0400
In-Reply-To: <HYC9VV01.E0R@hadar.amcc.com>
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <aradford@amcc.com>
Cc: akpm@osdl.org, james.bottomley@steeleye.com, hch@lst.de, linux-scsi@vger.kernel.org

Adam Radford wrote:
> +/* Command Packet */
> +typedef struct TW_Command {
> +	/* First DWORD */
> +	struct {
> +		unsigned char opcode:5;
> +		unsigned char sgl_offset:3;
> +	} byte0_offset;
> +	unsigned char size;
> +	unsigned char request_id;
> +	struct {
> +		unsigned char unit:4;
> +		unsigned char host_id:4;
> +	} byte3_offset;
> +	/* Second DWORD */
> +	unsigned char status;
> +	unsigned char flags;
> +	union {
> +		unsigned short block_count;
> +		unsigned short parameter_count;
> +	} byte6_offset;
> +	union {
> +		struct {
> +			u32 lba;
> +			TW_SG_Entry sgl[TW_ESCALADE_MAX_SGL_LENGTH];
> +#if BITS_PER_LONG > 32
> +			u32 padding[2];	/* pad to 512 bytes */
> +#else
> +			u32 padding;
> +#endif
> +		} io;
> +		struct {
> +			TW_SG_Entry sgl[TW_ESCALADE_MAX_SGL_LENGTH];
> +#if BITS_PER_LONG > 32
> +			u32 padding[3];
> +#else
> +			u32 padding[2];
> +#endif
> +		} param;
> +	} byte8_offset;
> +} TW_Command;

Bitfields aren't portable to big endian machines...  grep for 
__LITTLE_ENDIAN_BITFIELD and __BIG_ENDIAN_BITFIELD for examples.


> +/* Scatter gather element for 9000+ controllers */
> +typedef struct TAG_TW_SG_Apache {
> +	unsigned long address;
> +	u32 length;
> +} TW_SG_Apache;

is this a hardware structure?

This structure changes size and padding on 32-bit versus 64-bit machines.


> +/* Command Packet for 9000+ controllers */
> +typedef struct TAG_TW_Command_Apache {
> +	struct {
> +		unsigned char opcode:5;
> +		unsigned char reserved:3;
> +	} command;
> +	unsigned char unit;
> +	unsigned short request_id;
> +	unsigned char status;
> +	unsigned char sgl_offset;
> +	unsigned short sgl_entries;
> +	unsigned char cdb[16];
> +	TW_SG_Apache sg_list[TW_APACHE_MAX_SGL_LENGTH];
> +#if BITS_PER_LONG > 32
> +	unsigned char padding[8];
> +#endif
> +} TW_Command_Apache;

ditto bitfield comment.


> +/* New command packet header */
> +typedef struct TAG_TW_Command_Apache_Header {
> +	unsigned char sense_data[TW_SENSE_DATA_LENGTH];
> +	struct {
> +		char reserved[4];
> +		unsigned short error;
> +		unsigned char padding;
> +		struct {
> +			unsigned char severity:3;
> +			unsigned char reserved:5;
> +		} substatus_block;
> +	} status_block;
> +	unsigned char err_specific_desc[98];
> +	struct {
> +		unsigned char size_header;
> +		unsigned short reserved;
> +		unsigned char size_sense;
> +	} header_desc;
> +} TW_Command_Apache_Header;

bitfield


> +/* This struct is a union of the 2 command packets */
> +typedef struct TAG_TW_Command_Full {
> +	TW_Command_Apache_Header header;
> +	union {
> +		TW_Command oldcommand;
> +		TW_Command_Apache newcommand;
> +	} command;
> +} TW_Command_Full;
> +
> +/* Initconnection structure */
> +typedef struct TAG_TW_Initconnect {
> +	unsigned char opcode:5;
> +	unsigned char res1:3;
> +	unsigned char size;
> +	unsigned char request_id;
> +	unsigned char res2;
> +	unsigned char status;
> +	unsigned char flags;
> +	unsigned short message_credits;
> +	u32 features;
> +	unsigned short fw_srl;
> +	unsigned short fw_arch_id;
> +	unsigned short fw_branch;
> +	unsigned short fw_build;
> +	u32 result;
> +} TW_Initconnect;

ditto


> +/* Event info structure */
> +typedef struct TAG_TW_Event
> +{
> +	unsigned int sequence_id;
> +	unsigned int time_stamp_sec;
> +	unsigned short aen_code;
> +	unsigned char severity;
> +	unsigned char retrieved;
> +	unsigned char repeat_count;
> +	unsigned char parameter_len;
> +	unsigned char parameter_data[98];
> +} TW_Event;
> +
> +typedef struct TAG_TW_Ioctl_Driver_Command {
> +	unsigned int control_code;
> +	unsigned int status;
> +	unsigned int unique_id;
> +	unsigned int sequence_id;
> +	unsigned int os_specific;
> +	unsigned int buffer_length;
> +} TW_Ioctl_Driver_Command;
> +
> +typedef struct TAG_TW_Ioctl_Apache {
> +	TW_Ioctl_Driver_Command driver_command;
> +        char padding[488];
> +	TW_Command_Full firmware_command;
> +	char data_buffer[1];
> +} TW_Ioctl_Buf_Apache;
> +
> +/* Lock structure for ioctl get/release lock */
> +typedef struct TAG_TW_Lock {
> +	unsigned long timeout_msec;
> +	unsigned long time_remaining_msec;
> +	unsigned long force_flag;
> +} TW_Lock;
> +
> +/* GetParam descriptor */
> +typedef struct {
> +	unsigned short	table_id;
> +	unsigned short	parameter_id;
> +	unsigned short	parameter_size_bytes;
> +	unsigned short  actual_parameter_size_bytes;
> +	unsigned char	data[1];
> +} TW_Param_Apache, *PTW_Param_Apache;
> +
> +/* Response queue */
> +typedef union TAG_TW_Response_Queue {
> +	struct {
> +		u32 undefined_1: 4;
> +		u32 response_id: 8;
> +		u32 undefined_2: 20;
> +	} u;
> +	u32 value;
> +} TW_Response_Queue;

ditto


> +typedef struct TAG_TW_Info {
> +	char *buffer;
> +	int length;
> +	int offset;
> +	int position;
> +} TW_Info;
> +
> +/* Compatibility information structure */
> +typedef struct TAG_TW_Compatibility_Info
> +{
> +	char driver_version[32];
> +	unsigned short working_srl;
> +	unsigned short working_branch;
> +	unsigned short working_build;
> +} TW_Compatibility_Info;
> +
> +/* Command header for ATA pass-thru */
> +typedef struct TAG_TW_Passthru
> +{
> +	struct {
> +		unsigned char opcode:5;
> +		unsigned char sgloff:3;
> +	} byte0;
> +	unsigned char size;
> +	unsigned char request_id;
> +	struct {
> +		unsigned char aport:4;
> +		unsigned char host_id:4;
> +	} byte3;
> +	unsigned char status;
> +	unsigned char flags;
> +	unsigned short param;
> +	unsigned short features;
> +	unsigned short sector_count;
> +	unsigned short sector_num;
> +	unsigned short cylinder_lo;
> +	unsigned short cylinder_hi;
> +	unsigned char drive_head;
> +	unsigned char command;
> +	TW_SG_Entry sg_list[TW_ATA_PASS_SGL_MAX];
> +	unsigned char padding[12];
> +} TW_Passthru;

ditto


> +typedef struct TAG_TW_Device_Extension {
> +	u32                     *base_addr;
> +	unsigned long	       	*generic_buffer_virt[TW_Q_LENGTH];
> +	unsigned long	       	generic_buffer_phys[TW_Q_LENGTH];
> +	unsigned long	       	*command_packet_virt[TW_Q_LENGTH];
> +	unsigned long		command_packet_phys[TW_Q_LENGTH];
> +	struct pci_dev		*tw_pci_dev;
> +	struct scsi_cmnd	*srb[TW_Q_LENGTH];
> +	unsigned char		free_queue[TW_Q_LENGTH];
> +	unsigned char		free_head;
> +	unsigned char		free_tail;
> +	unsigned char		pending_queue[TW_Q_LENGTH];
> +	unsigned char		pending_head;
> +	unsigned char		pending_tail;
> +	int     		state[TW_Q_LENGTH];
> +	unsigned int		posted_request_count;
> +	unsigned int		max_posted_request_count;
> +	unsigned int	        pending_request_count;
> +	unsigned int		max_pending_request_count;
> +	unsigned int		max_sgl_entries;
> +	unsigned int		sgl_entries;
> +	unsigned int		num_aborts;
> +	unsigned int		num_resets;
> +	unsigned int		sector_count;
> +	unsigned int		max_sector_count;
> +	unsigned int		aen_count;
> +	struct Scsi_Host	*host;
> +	long			flags;
> +	int			reset_print;
> +	TW_Event                *event_queue[TW_Q_LENGTH];
> +	unsigned char           error_index;
> +	unsigned char		event_queue_wrapped;
> +	unsigned int            error_sequence_id;
> +	int                     ioctl_sem_lock;
> +	u32                     ioctl_msec;
> +	int			chrdev_request_id;
> +	wait_queue_head_t	ioctl_wqueue;
> +	struct semaphore	ioctl_sem;
> +	char			aen_clobber;
> +	unsigned short		working_srl;
> +	unsigned short		working_branch;
> +	unsigned short		working_build;
> +} TW_Device_Extension;
> +
> +#pragma pack()
> +
> +#endif /* _3W_9XXX_H */


General comment:  bitfields are annoying.  Even if you do apply the 
__BIG_ENDIAN_BITFIELD switching, the compiler still generates crappy 
code for bitfields (as do all compilers).

You'll find that using bitmasks on natural integers often results in 
_much_ better generated code out of the compiler.

	Jeff


